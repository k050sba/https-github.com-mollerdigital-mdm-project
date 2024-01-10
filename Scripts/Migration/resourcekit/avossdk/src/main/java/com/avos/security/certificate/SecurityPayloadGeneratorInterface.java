package com.avos.security.certificate;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SignatureException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

public interface SecurityPayloadGeneratorInterface {
	public String getEncryptedSecurityPayload(String pathToHubServer, String interactionId, String orsId, String requestName, String applicationName, String userName) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, SignatureException;

}
