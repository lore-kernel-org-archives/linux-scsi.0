Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WRQSNeEn"
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BB61719
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 08:55:29 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2c9ef682264so12382071fa.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 08:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1701968127; x=1702572927; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RG04rjnWO0d908QbUVQ/LgG+xuL2cBgHBUtcEoL4cFs=;
        b=WRQSNeEn5jDV7pDv9OvKfqrW9dlZ9oaIMe3fj1y5ZO4xadjKfvkov8bOfUY50AbAxS
         mlQ4eSbps4Kepf7pOtKstypwGjhH7LzbkpP2Q1LjW9tpDG3iCJZ2fyo1NCdIj3lbIJr5
         ktt4xSfDBh+rh9xd3la5Px7kWHhbEkri0+wn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701968127; x=1702572927;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RG04rjnWO0d908QbUVQ/LgG+xuL2cBgHBUtcEoL4cFs=;
        b=axfXljZ4wQ8ArvynYUXV4hqGWKyDY/tPHJdpBIvFWcUYvatkYpQGpi2TKBlJ8p8dg4
         J/lPh/ZxMrWzkvaivQIFP+imoRdiIXCBHX503iVPMrZXu2rgFFfWJTXKlfUNUQonMKNo
         9zhZMkGSwSN51RDIXJ4jaFtfiriNZiGl+SDHygAk2DSyW0JDrFj+zNk+Io/a6s7X+5ty
         8XLpM2wPLQ1T6jmtYGmGcrCV7vXe8t0/OXoqhRMt7XVvko2h8q7S3bxmXeCuezEd1JUn
         i6mvAL2rN0d7dtI4d5lVakLqeM6zoW9jNL1OYdsfQf8tP73nPgoNuQTrPoyo1OA5XVQS
         TWyw==
X-Gm-Message-State: AOJu0YyM+FHrtz+qr8gpxU2EiLWj+YuHjyranRI7lBsjDaNFmCWqAXU/
	UC+FU6jaqJ01zr3KqoS6A2PilygGdar9dktBe+Xu
X-Google-Smtp-Source: AGHT+IECxJ0njXYcCmrrnyXcQOq1jzj+9ikiEqch57mV1a1CnUG3Xw/m7n7CdvvEMYYH0FgSJUuMbZ9KrSUl0KkNnDo=
X-Received: by 2002:a2e:a30b:0:b0:2c9:d874:20d7 with SMTP id
 l11-20020a2ea30b000000b002c9d87420d7mr1525940lje.97.1701968127192; Thu, 07
 Dec 2023 08:55:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231206152513.71253-3-ranjan.kumar@broadcom.com> <20231206165637.GA717462@bhelgaas>
In-Reply-To: <20231206165637.GA717462@bhelgaas>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Thu, 7 Dec 2023 09:55:09 -0700
Message-ID: <CAFdVvOyCCEOLs4z-aOnuEdcnak52HqvNMUOQfv-6OwMTSkaGBg@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] mpi3mr: Support PCIe Error Recovery callback handlers
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, rajsekhar.chundru@broadcom.com, 
	sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com, 
	prayas.patel@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000a9c3a6060bee55fa"

--000000000000a9c3a6060bee55fa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 9:56=E2=80=AFAM Bjorn Helgaas <helgaas@kernel.org> w=
rote:
>
> On Wed, Dec 06, 2023 at 08:55:11PM +0530, Ranjan Kumar wrote:
> > The driver has been upgraded to include support for the
> > PCIe error recovery callback handler which is crucial for
> > the recovery of the controllers. This feature is
> > necessary for addressing the errors reported by
> > the PCIe AER (Advanced Error Reporting) mechanism.
> >
> > Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> > Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> > ...
>
> > +static int
> > +mpi3mr_get_shost_and_mrioc(struct pci_dev *pdev,
> > +     struct Scsi_Host **shost, struct mpi3mr_ioc **mrioc)
> > +{
> > +     *shost =3D pci_get_drvdata(pdev);
> > +     if (*shost =3D=3D NULL) {
> > +             dev_err(&pdev->dev, "pdev's driver data is null\n");
> > +             return -1;
> > +     }
> > +
> > +     *mrioc =3D shost_priv(*shost);
> > +     if (*mrioc =3D=3D NULL) {
> > +             dev_err(&pdev->dev, "shost's private data is null\n");
> > +             *shost =3D NULL;
> > +             return -1;
>
> I'm a little bit skeptical about these checks for NULL, although I do
> see that the existing code has similar "if (!shost)" checks.
>
> Usually these checks will only find memory corruption or logic errors,
> and silently bailing out, as the previous "if (!shost)" checks do,
> just masks a serious problem.  Logging errors, as you do here, is a
> little better, but I think it's better to just take the exception when
> we dereference the NULL pointer later because that's impossible to
> ignore and usually gives more clues about what went wrong.
>
Agree, however, I wouldn't want to crash the system from this driver.
Will add WARN notices and move this into a separate patch later. For
now, will check this inside the PM functions as we do currently for
other cases.
> > +}
> > +     return 0;
> > +}
>
> The addition and use of mpi3mr_get_shost_and_mrioc() looks like it
> could be a separate patch.  If so, it might be nice to split this into
> several smaller, simpler patches
Will detach this from this patch and will submit another separate patch.

>
> >  static int __maybe_unused
> >  mpi3mr_suspend(struct device *dev)
> >  {
> >       struct pci_dev *pdev =3D to_pci_dev(dev);
> > -     struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
> > +     struct Scsi_Host *shost;
> >       struct mpi3mr_ioc *mrioc;
> >
> > -     if (!shost)
> > -             return 0;
> > +     if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
> > +             return -1;
>
> Is -1 really the best return value here?  It seems like usually a
> negative errno is returned.
The __suspend_report_result just prints the return value, so i thought
-1 is fine as we already print a error message. Do you recommend to
use another negative (non -1) number for differentiation between
generic error and this?


>
> Bjorn
>

--000000000000a9c3a6060bee55fa
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
v82E+npLwqC8bSHh1m6BJewfpawx72uKM9aFs6SVpLPtN6a5369OCwVeEwkk2FeFU9tZXWBnI4Wu
d1Q4a3vhOColD6PdTWv74Ez2I3ahCkmpeEQ1YMt61TUH3W8NUJJeYN2xkR6OGsA1AgMBAAGjggHc
MIIB2DAOBgNVHQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRw
Oi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcnQwQQYIKwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJz
b25hbHNpZ24yY2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZo
dHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRC
MEAwPqA8oDqGOGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3JsMCYGA1UdEQQfMB2BG3NhdGh5YS5wcmFrYXNoQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
VyBc/F5XGkYNCP9Rb96mru8lU4AwDQYJKoZIhvcNAQELBQADggEBACiysbqj0ggjcc9uzOpBkt1Q
nGtvHhd9pbNmshJRUoNL11pQEzupSsUkDoAa6hPrOaJVobIO+yC84D4GXQc13Jk0QZQhRJJRYLwk
vdq704JPh4ULIwofTWqwsiZ1OvINzX9h9KEw/+h+Mc3YUCO7tvKBGLJTUaUhrjxyjLQdEK1Xp/8B
kYd5quZssxYPJ3nl37Moy/U9ZM2F0Ivv4U3wyP5y5cdmBUBAGOd94rH60fVDVogEo5F9gXrZhT/4
jKzCG3LclOOzLinCkK2J5GYngIUHSmnqk909QPG6jkx5RJWwkpTzm+AAVbJ9a+1F/8iR3FiDddEK
8wQJuWG84jqd/9wxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAR7I+JG
Lgtd3aNfsO9FpT/UK29WDrhXcwq3d5RP+upxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIzMTIwNzE2NTUyN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAmTrHEsy9j2Gs/bE8e4USUwWYa
OSjyo8hZRRBRxIkdbXnSpfVxzxdq5HQA+9eQzTut65j8oHHXQD8C+Cv1w5tLHbH0PPVhmpmU9ia5
XfHeN3F/8gLDx72fZHePu+BYfQxMhR2zSP1UWQ3497AbswQcdVx+TPvSQpPDg9npg/fTiaqUoWak
zugkRc9Vt9Ue3evWfeltxjPalQwPf1rUjGnVl68wCA3JMcZ+aO5B/9aXDhGCr62lLWLPfbX/JDr5
cuRHE9tHaUoSGlEeDTtNUac3BWxX1HoxGN8ba1PAcyr0UyF2HBJx2c9aLxcKvuapZlwpe3Aw8tKs
H1iuifTZdUL+
--000000000000a9c3a6060bee55fa--
