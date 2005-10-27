From: Erik Slagter <erik@slagter.name>
Subject: Re: [PATCH/RFC] SCSI mid-layer suspend/resume
Date: Thu, 27 Oct 2005 11:17:18 +0200
Message-ID: <1130404638.8768.4.camel@localhost.localdomain>
References: <20051024160531.7d879a7c.randy_d_dunlap@linux.intel.com>
	 <435D6E47.1030409@pobox.com>
	 <20051025142529.7b23bbc0.randy_d_dunlap@linux.intel.com>
	 <435EA5AB.9010805@pobox.com>  <43604B14.7080903@rtr.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-lHetP/kUvCtgA4wI9Ufy"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43604B14.7080903@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Jeff Garzik <jgarzik@pobox.com>, Randy Dunlap <randy_d_dunlap@linux.intel.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, axboe@suse.de, hch@lst.de
List-Id: linux-scsi@vger.kernel.org


--=-lHetP/kUvCtgA4wI9Ufy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-10-26 at 23:35 -0400, Mark Lord wrote:

> I have an extra hard drive caddy for my Dell notebook,
> with a different 2.5" drive mounted in it.
>=20
> When using THAT drive, my machine cannot resume successully
> from suspend-to-RAM.  Hangs with the hard drive light on solid
> some of the time, and not on other times.
> Drove me crazy figuring this out, but I eventually tried a
> different drive and it worked fine.
>=20
> So.. not all drives work for me.

Any idea how this extra drive is actually connected? I was thinking PATA
drive with SATA bridge, PATA directly (comes to mind...) or maybe it's
even a SATA drive connected directly...

--=-lHetP/kUvCtgA4wI9Ufy
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGFjCCAs8w
ggI4oAMCAQICAw9TczANBgkqhkiG9w0BAQQFADBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhh
d3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVt
YWlsIElzc3VpbmcgQ0EwHhcNMDUwODE4MTE1NDA1WhcNMDYwODE4MTE1NDA1WjBDMR8wHQYDVQQD
ExZUaGF3dGUgRnJlZW1haWwgTWVtYmVyMSAwHgYJKoZIhvcNAQkBFhFlcmlrQHNsYWd0ZXIubmFt
ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANAMKW15OgreNb+Wd++Xcw6uNJUXXIfX
56u1rtTObMmbbDY2wNc4Iqwbuwaysvox3z+YElXBibE8BAyV1iMjhee4mOfAy38dGHtWDxhOGke8
VpkyY8DSWgMN5p4egTiT6YNdHW75iiQ+Vh5zMHju1UXnIqgf5zkUGkNuxYp15jLZvRDbfA5H+Sil
jbZGB2fiPOJHpyI61ZidcMgdow31qm70/oe6vXxhSZLzo7OLvExE+mQHwbCSIJMN/hPTK1z0lmQ1
kkaEjHrefqIgoF9Dk/WfOtulzvR3xBzDL50GZ32BxT/OhXYe1SHEJpSM1S/aq8TBQJYwjzREWyDh
0OYsmr0CAwEAAaMuMCwwHAYDVR0RBBUwE4ERZXJpa0BzbGFndGVyLm5hbWUwDAYDVR0TAQH/BAIw
ADANBgkqhkiG9w0BAQQFAAOBgQCCpzoneRQIKsUO8zSnwQ7yhJTrS/EaDibiIVrkkCbzXwCiHFAi
7nmTRF0DlLVF3Ssf97ITWT/RSdkj9Xke0OHH7724PJdfpA6OglMnx2i7IcJLzPgPjB+fOmfR0nYX
UYKuzGxTOXmshLmPcwKdpFuRLLk7n+vrTAwJYJI++crhJzCCAz8wggKooAMCAQICAQ0wDQYJKoZI
hvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENhcGUxEjAQBgNVBAcT
CUNhcGUgVG93bjEaMBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAmBgNVBAsTH0NlcnRpZmlj
YXRpb24gU2VydmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBDQTErMCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1haWxAdGhhd3RlLmNvbTAeFw0wMzA3
MTcwMDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUg
Q29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwg
SXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAxKY8VXNV+065yplaHmjAdQRw
nd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FWy688Cwfn8R+R
NiQqE88r1fOCdz0Dviv+uxg+B79AgAJk16emu59l0cUqVIUPSAR/p7bRPGEEQB5kGXJgt/sCAwEA
AaOBlDCBkTASBgNVHRMBAf8ECDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwu
dGhhd3RlLmNvbS9UaGF3dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3JsMAsGA1UdDwQEAwIBBjApBgNV
HREEIjAgpB4wHDEaMBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0xMzgwDQYJKoZIhvcNAQEFBQADgYEA
SIzRUIPqCy7MDaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYfqi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6E
sZkbAMUaC4J0niVQlGLH2ydxVyWN3amcOY6MIE9lX5Xa9/eH1sYITq726jTlEBpbNU1341YheILc
IRk13iSx0x1G/11fZU8xggHvMIIB6wIBATBpMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3
dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1h
aWwgSXNzdWluZyBDQQIDD1NzMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0wNTEwMjcwOTE3MThaMCMGCSqGSIb3DQEJBDEWBBQDIAYcBoJ2Ei6N
AejORVzKmBZODDANBgkqhkiG9w0BAQEFAASCAQAs0jJAHEQjkRKmmVIpbihhpiBElxOk9MvKUpXz
/R63DJ69xRh7kEGILj5EHD7QxAlP+1R1aHGIrLq8mTvAkfRhefbPl+KJMk2ihmC7PgWVrUMJ045s
t1RTl2uy8Ppl8aPONJ3KDtdhwzI/NvrKNBEZtNKTvrf3QojWKFi/HW+u2thBo7jxquAHBAr6s7UH
mR2hJIx6rmDr1p6J+cFdXc7dD1H+jw5dCEmknheH+R9aD+igx7QgnUXRjMG1d05RnYcVWGWQUUhf
n08FEQqyMx/eF4hbz5E+ctFGYfJoWC6iR8MjjFRdjXIrChaZzUENpCWg2/1ITj7V1n9L0AKYzq/s
AAAAAAAA


--=-lHetP/kUvCtgA4wI9Ufy--
