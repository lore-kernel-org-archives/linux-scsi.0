Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998487;
	b=xhd6a2p4uK6TsI6Hg2IeFhg4LL6/LFFvbyXpk2xgNybhMhsZ46hdxXcO7dF7MIwcTqZa
	 0aW2qtPbCViAPCYKNLj/k/2RnIaJ3d0OiJeQhXKAdlhG+fEwb0fQs+pbc4QnJo62JkHgn
	 TgpTtuiQTQvJVEACKnH/WypxTUZXuYvLIuKREJP+t49cZY81xsL8z40/pdlo1KhQYx9Ln
	 Xwi1MNz1j92OPNXN+ruacKQ6QDJAIuV/WJCIXTtqSIbYRuwBtS45DtZuwo1P2JcD0jvJX
	 aVrBOpPwHQqY5JQsTHdvnOMNXalDnOAyLRjpISmvnOhnZgjvRD8l9qOUNuEWJGhwczw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998487;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=g9bKPqfb0MzWNrs1/Oo1XSaIlZ5Cr11KbaSH+82c2oE=;
	b=NE0cT18BrUWyI7CZZftkutvxomV2NGh3Gp8jfd3nDHCzIzpPMD315nfQCGd7tS0Srx7I
	 BDeg7Ax/op9w54/MwExSH+UPhoO/jTNIXLKwBlW5BNEWgfpD82mS+4DtbeGxd4tvA11iJ
	 3UOVpArr3h1R1vC/kFjUvFL/vVZ7cSGQAdPo893UIfp1nChlyWuBf/gchcjc1AVI5BJjk
	 Kt6HybbcAzzGfEy1GCJ4l8FQzN0Obdvg6oWrp+1FbdARHfYr+ODCaoI0HT7tUwCBTCiAr
	 IvgeC2aqe7YKwBwa48s8KaVmXHTSy1TNyPs8WSU5wZVNokpuF/91I85shaKvemv+mpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LUEPDlVI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E61F606A325
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LUEPDlVI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C051F000C5;
	Wed, 18 Nov 2026 10:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998487;
	bh=g9bKPqfb0MzWNrs1/Oo1XSaIlZ5Cr11KbaSH+82c2oE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=LUEPDlVIrBIIwQmndHbiUANf9+fwAnQ+k90Zr4LrrMmem8ZP8UijX0/MLRKnBQN0b
	 e6pZYGHtjSnpU2iE1vAc4RTGYvPF+qnplZqUX6q3+hoHdJeac4TsKcqlof4LdjSyJ4
	 gwUy5WuCEjZ84i9vdQxx4Htx9pAB3xPgd3/OdsdnZoRncQE/7O5ZtOrM+pn6xCrGSp
	 8b7wHZLyeHctqdvM07fIVW7/AdUskyTn7JtX1WABQMMeZpscL2stIJstl60R7CJpdM
	 rn8Ayk1z8PeFG9ny1FiaU5LnJyYbbG/pxzteJGWq6SpAng+PCFcCDEF7H/pHK6VaF/
	 wL9T5k6xPWDcA==
Message-ID: <sashiko-outbox-220732@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/37] scsi: mpt3sas: Pin Scsi_Host while an ioctl is
 using its ioc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:41:26 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] scsi: mpt3sas: premature publication of ioc on
  mpt3sas_ioc_list in _scsih_probe()
- [Medium] scsi: mpt3sas: scsi_host_get() in _ctl_verify_adapter() does
  not block teardown
- [Low] scsi: mpt3sas: missing Fixes trailer on bug-fix commit
--

commit 60e7b794a30f8451bb00b5913b1698ad94d9c3dd
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Pin Scsi_Host while an ioctl is using its ioc
>
> Take a Scsi_Host reference in _ctl_verify_adapter() and release it
> once the ioctl is done, so the adapter can't be torn down while an
> ioctl is in flight.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This is a bug fix for the unreferenced ioc lookup in the ioctl path.  Should
it include a Fixes tag?

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
> index 8bb947004885b..f4eeef572f6ec 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -447,6 +447,11 @@ _ctl_verify_adapter(int ioc_number, struct MPT3SAS_A=
DAPTER **iocpp,
>  				continue;
>  		}
>  out:
> +		if (!ioc->shost || !scsi_host_get(ioc->shost)) {
> +			spin_unlock(&gioc_lock);
> +			*iocpp =3D NULL;
> +			return -1;
> +		}
>  		spin_unlock(&gioc_lock);
>  		*iocpp =3D ioc;
>  		return ioc_number;

[Severity: Medium]
Does scsi_host_get(ioc->shost) prevent scsih_remove() from tearing down
shost->tag_set while an ioctl is already in flight?

scsi_host_get() pins the Scsi_Host memory allocation via shost->shost_gendev
and blocks new lookups once scsi_remove_host() sets SHOST_DEL, but it does
not take shost->tagset_refcnt or block scsih_remove().  If an ioctl acquires
ioc->pci_access_mutex and passes the ioc->remove_host check before
scsih_remove() sets ioc->remove_host =3D 1, scsih_remove() proceeds without
acquiring ioc->pci_access_mutex until mpt3sas_base_detach() ->
mpt3sas_base_free_resources():

CPU0                                  CPU1
_ctl_ioctl_main()
  _ctl_verify_adapter()
    scsi_host_get(ioc->shost)
  mutex_lock(&ioc->pci_access_mutex)
  if (ioc->remove_host) // false
                                      scsih_remove()
                                        ioc->remove_host =3D 1;
                                        ...
                                        sas_remove_host(shost)
                                          scsi_remove_host(shost)
                                            ...
                                            blk_mq_free_tag_set(&shost->tag=
_set)
  _ctl_do_reset()
    mpt3sas_base_hard_reset_handler()
      mpt3sas_wait_for_commands_to_complete()
        scsi_host_busy(ioc->shost)
          blk_mq_tagset_busy_iter()   <-- use-after-free / NULL dereference
                                        mpt3sas_base_detach(ioc)
                                          mpt3sas_base_free_resources(ioc)
                                            mutex_lock(&ioc->pci_access_mut=
ex)

Acquiring ioc->pci_access_mutex around setting ioc->remove_host =3D 1 in
scsih_remove(), or synchronizing with in-flight ioctls before
sas_remove_host(), would prevent teardown from racing with an active ioctl.

[ ... ]

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index a77bbc3d2b666..b30a215141c35 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -13496,11 +13496,12 @@ _scsih_probe(struct pci_dev *pdev, const struct=
 pci_device_id *id)
>  		return -ENODEV;
>  	}
> =20
> +	/* shost must be valid before the ioc becomes visible to ioctls */
> +	ioc->shost =3D shost;
>  	INIT_LIST_HEAD(&ioc->list);
>  	spin_lock(&gioc_lock);
>  	list_add_tail(&ioc->list, &mpt3sas_ioc_list);
>  	spin_unlock(&gioc_lock);
> -	ioc->shost =3D shost;
>  	ioc->pdev =3D pdev;
>  	ioc->scsi_io_cb_idx =3D scsi_io_cb_idx;
>  	ioc->tm_cb_idx =3D tm_cb_idx;

[Severity: Medium]
Can an ioctl on /dev/mpt3ctl or /dev/mpt2ctl access ioc before _scsih_probe=
()
has initialized its mutexes and fields?

In _mpt3sas_init(), mpt3sas_ctl_init() registers the misc devices before
pci_register_driver() runs, and the device nodes remain active across hotpl=
ug
events.  Because scsi_host_alloc() sets shost->shost_state to SHOST_CREATED,
scsi_host_get(ioc->shost) in _ctl_verify_adapter() succeeds as soon as ioc =
is
added to mpt3sas_ioc_list:

CPU0                                  CPU1
_scsih_probe()
  ioc->shost =3D shost;
  list_add_tail(&ioc->list,
                &mpt3sas_ioc_list);
                                      _ctl_ioctl_main()
                                        _ctl_verify_adapter()
                                          scsi_host_get(ioc->shost)
                                        mutex_lock(&ioc->pci_access_mutex)
                                          <-- uninitialized mutex
                                        if (ioc->is_driver_loading || ...)
                                          // still 0
                                        mutex_lock(&ioc->ctl_cmds.mutex)
                                          <-- uninitialized mutex
  ioc->pdev =3D pdev;
  ...
  mutex_init(&ioc->pci_access_mutex);
  ...
  ioc->is_driver_loading =3D 1;
  mpt3sas_base_attach(ioc);
    mutex_init(&ioc->ctl_cmds.mutex);

At the point list_add_tail() publishes ioc, ioc->pdev is still NULL,
ioc->pci_access_mutex has not been initialized, ioc->is_driver_loading is
still 0 (until after alloc_ordered_workqueue()), and ioc->ctl_cmds.mutex is
not initialized until mpt3sas_base_attach().  Adding ioc to mpt3sas_ioc_list
only after ioc->pci_access_mutex is initialized and ioc->is_driver_loading =
is
set to 1 (or after mpt3sas_base_attach() succeeds) would close this window.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D3
