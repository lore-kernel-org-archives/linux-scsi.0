From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH V2 2/4] [SCSI] drivers/scsi/ufs: Add PCI glue driver
Date: Fri, 13 Jul 2012 18:01:58 +0200
Message-ID: <4746865.F6XkGPQgWn@eto>
References: <1342189698-20393-1-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7993383.oMlWoQhI4o"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1342189698-20393-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com
List-Id: linux-scsi@vger.kernel.org


--nextPart7993383.oMlWoQhI4o
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Vinayak Holikatti wrote:

> +static int __devinit
> +ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct ufs_hba *hba;
> +	void __iomem *mmio_base;
> +	int err;
> +
> +	err = pci_enable_device(pdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "pci_enable_device failed\n");
> +		goto out_error;
> +	}

My question as basically every time at this point: why not use devres, i.e. 
pcim_enable_device()? This would make the cleanup and error handling much 
easier. See Documentation/driver-model/devres.txt.

> +
> +	pci_set_master(pdev);
> +
> +

Duplicate newline.

Eike
--nextPart7993383.oMlWoQhI4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlAARnwACgkQXKSJPmm5/E7vqQCePm5KApz+P+Z70Wke1wm/YZ6l
MIMAnihTzDvQ5WZI4Xg/Tm58yjAYO7+O
=3dIT
-----END PGP SIGNATURE-----

--nextPart7993383.oMlWoQhI4o--
