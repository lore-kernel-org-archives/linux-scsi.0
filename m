Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAF62DC781;
	Wed,  1 Oct 2025 06:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759299095; cv=pass; b=Zr6pdOcujysXnbvBRdpwSu5quC+AqpoWMo02/kbTmwvTTwXmA539MWF4SHFNu2BvTsPbsT+eSXe/DAHrWTgisjYAHVJGDKMabGGT8rijObmfjYgEoWaDqwuI4Kn7bnn2eJh5/A6QtXGjKzjKKl2mwsRCPa4O7Z4vqxSLgHqum0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759299095; c=relaxed/simple;
	bh=HDws+0WHACs7h+lgatRJcrzTD8NRfGEzmeUc4oV7kVw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=nFZpy/blneg9aSjRO5rv+bHxJ+NTorpxxk+hTx+owyk8r1WMLdXopmyd812JQyEcdiXdfF5SIb1F0slY0Mu18NuoeRrPiZaAZkUEY4ntuQX02TRs5mr9BempdLh0G7Axnre3xWbLoDB9wvcd0M2G0n17Y8ccKxNFQEvZvgGmjCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Ig82TzVB; arc=pass smtp.client-ip=81.169.146.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Ig82TzVB"
ARC-Seal: i=1; a=rsa-sha256; t=1759298897; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=enf3ITdm3r/+U8NCFFhW3QiG2wIePf+GxClWXngRzsVNSEWQl/GJCeJ6dWS2jTGihh
    Nlk23Vu39cYitlHcIFrmLd55X6nF7gkNd94t7pQ+XCIyqfARbxxOq5kAE8DJ18hOvt4X
    7hGB8lp9uRdgb2QMLFmcO25XD8ZJCrz9QO+E9ae6N7PeKg+r589DLUdndmO/pL+JLZe1
    iyhoJL80oDV7Qa5Yw449qY3sR8k+lKrrdTJlr9DKjYobrV/rGoBSkFKhGDmhXOmlzUp4
    AFTbnXGAojsRZPgpxVA3JKXDF5j9walgH/QOFpeFnCF6saw5h2fLKEmE5Qafdhmr9sN7
    NzTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759298897;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=DNRE7d9XoF6Bh3ymYMMqBGHCU94maYTRPui1GHqUTdo=;
    b=FPFAODbbNxlGX1jdVwf2+9R1Ut3qZ152LVQXtvLZ+CRX88ubN+ZPy0EOQaxgu3AD9k
    1acyHnLQxxXRbYzxdNkB/JHfXJU9Do4HpW+RJn9GJfD4IkZ0GsiRbvxsieHKzVI7uGb/
    mmJq+iUdOulWIXxtvvtpgLuNytl/GbHkf7XlOazREDW4jgLYyolRK7XgqQy3jjTZFt4I
    Rj9D/Nl359/qTwZMvpnUOYCYE6+HFpDlJoWsaGgdEOSWbeZGii4HM+DF171McoaJ9wGW
    RZRYPVSVf+blaoh2Vvir5B5/0H6ZsxFoJTHrXSuhVwhEP/sn00FdfbHKczEycaZ0z15Z
    yLVw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759298897;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=DNRE7d9XoF6Bh3ymYMMqBGHCU94maYTRPui1GHqUTdo=;
    b=Ig82TzVBqfQTN+aRVVI5Z3tC1jPh6OL1kxdGgEjkE398dULrLJrwWoaF+EyWxVy5Pv
    GZRTAEfVgt2vqjq+DyaJ3UgSZOES2TKU59IlBsqWfzsoREn4yUtxgxYz1VGAuQTCqmQh
    MnNFeMR3Iw775cINhbiP3OUHkQYTb3p7t3hX/0p/NvJXDYHrMMVuUauDKJDxiWfJ1scP
    63glXidYdKm4HiSKqOF/O/gKSqrrP+5BMVWBeEMV+2/JCaYLgnY9ore+eCaurFABXb11
    RHLzXgcVhR2shx/qgebIy7LMUDTyzsYobTwriMg32hAIy+WkgdLUBKEAX1b5119Nf6vm
    G+ow==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2JmZOo2yQsAdmCB+Gw=="
Received: from Munilab01-lab.fritz.box
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc619168GY7G
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 1 Oct 2025 08:08:16 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: avri.altman@wdc.com,
	bvanassche@acm.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	can.guo@oss.qualcomm.com,
	ulf.hansson@linaro.org,
	beanhuo@micron.com,
	jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bean Huo <beanhuo@iokpp.de>
Subject: [PATCH v2 0/3] Add OP-TEE based RPMB driver for UFS devices
Date: Wed,  1 Oct 2025 08:08:02 +0200
Message-Id: <20251001060805.26462-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

This patch series introduces OP-TEE based RPMB (Replay Protected Memory Block)
support for UFS devices, extending the kernel-level secure storage capabilities
that are currently available for eMMC devices.

Previously, OP-TEE required a userspace supplicant to access RPMB partitions,
which created complex dependencies and reliability issues, especially during
early boot scenarios. Recent work by Linaro has moved core supplicant
functionality directly into the Linux kernel for eMMC devices, eliminating
userspace dependencies and enabling immediate secure storage access. This series
extends the same approach to UFS devices, which are used in enterprise and mobile
applications that require secure storage capabilities.

Benefits:
- Eliminates dependency on userspace supplicant for UFS RPMB access
- Enables early boot secure storage access (e.g., fTPM, secure UEFI variables)
- Provides kernel-level RPMB access as soon as UFS driver is initialized
- Removes complex initramfs dependencies and boot ordering requirements
- Ensures reliable and deterministic secure storage operations
- Supports both built-in and modular fTPM configurations.

v1 -- v2:
	1. Added fix tag for patch [2/3]
	2. Incorporated feedback and suggestions from Bart

RFC v1 -- v1:
        1. Added support for all UFS RPMB regions based on https://github.com/OP-TEE/optee_os/issues/7532
        2. Incorporated feedback and suggestions from Bart


Bean Huo (3):
  rpmb: move rpmb_frame struct and constants to common header
  scsi: ufs: core: fix incorrect buffer duplication in
    ufshcd_read_string_desc()
  scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices

 drivers/misc/Kconfig           |   2 +-
 drivers/mmc/core/block.c       |  42 ------
 drivers/ufs/core/Makefile      |   1 +
 drivers/ufs/core/ufs-rpmb.c    | 253 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |  13 ++
 drivers/ufs/core/ufshcd.c      |  32 ++++-
 include/linux/rpmb.h           |  44 ++++++
 include/ufs/ufs.h              |   4 +
 include/ufs/ufshcd.h           |   3 +
 9 files changed, 346 insertions(+), 48 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-rpmb.c

-- 
2.34.1

