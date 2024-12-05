Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B513EA9A;
	Thu,  5 Dec 2024 03:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733368392; cv=none; b=m/6SPOuxXgP4AfkgzbYRCGfgfBECkUD+J9vAh7t/Y3nVRiYOt4vOSWTQUXbZdUpS5W3TWb/uytRlhMldem1MvHsvT9m3bRA8JF1mU3kxD5ZIHpRtSLjWtbrxm7tjOancMJiRJoyifPVPuaELFE+SCO8Lcuf4TNriDi9qKXgQPC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733368392; c=relaxed/simple;
	bh=S6U6N3BrgifK/MhuHSN2mX6igqOw+eEk/b5KB7r//fw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=djI3Y+PWxxMkiAJlaqHDJKpEozlWPc33CasTUxPFEsQl5egJQINmfQfMu/XZdb4Pz5OtBh/HB/0L7w7hOv+Pl/rjAMyq3+0YZP0ksiElX6k+KqZrjy1PtHWTUVT1XUtEcjAyeYGKbPG+FPsU5u4CHOYyMsaG8GXUNsn+mTKdcWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yWrYmB4l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yWrYmB4l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=IuEXT0ZxkFP5mjNKuU9spG+uGaTgHhCC0eXuN9pMpxI=; b=yWrYmB4liOjk59QfQS4Bg4cDFN
	ZNSuC6QPt6GXuDv8HmDpBTagyrFy8I9qTWFf3x8lgY2cyCMzl1QYGlBp1+5h/w/ASDXMv5gFORch3
	HoGvNamPXpOkaez7RxVdHTctW6LYD60+FWSo68UpJv9n5d9+OwM2Cm6VHFTLuoHUV+JmO15/hhIs+
	Qzi1WtbXIvtrweuW2yd+KVY3JMBRSYBxwQacglC0eCy3PAe2nW7WZM4S3Iy/jPz/jOVyr5M5w0kxG
	2ZxDw7xKUz1I7cIfHXhbfRCzQ7BD3HELrkkhcD6ZSJOpwzcksAAXBQCIhYjotaIPu0/s2gR8qJZuT
	nwc31rVg==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tJ2If-0000000EdB2-0OcT;
	Thu, 05 Dec 2024 03:13:09 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: [PATCH] scsi: Docs: remove init_this_scsi_driver()
Date: Wed,  4 Dec 2024 19:13:07 -0800
Message-ID: <20241205031307.130441-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Finish removing mention of init_this_scsi_driver() that was removed
ages ago.

Fixes: 83c9f08e6c6a ("scsi: remove the old scsi_module.c initialization model")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/scsi/scsi_mid_low_api.rst |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- linux-next-20241204.orig/Documentation/scsi/scsi_mid_low_api.rst
+++ linux-next-20241204/Documentation/scsi/scsi_mid_low_api.rst
@@ -625,7 +625,7 @@ Interface Functions
 ===================
 Interface functions are supplied (defined) by LLDs and their function
 pointers are placed in an instance of struct scsi_host_template which
-is passed to scsi_host_alloc() [or scsi_register() / init_this_scsi_driver()].
+is passed to scsi_host_alloc() or scsi_register().
 Some are mandatory. Interface functions should be declared static. The
 accepted convention is that driver "xyz" will declare its sdev_configure()
 function as::
@@ -636,8 +636,8 @@ and so forth for all interface functions
 
 A pointer to this function should be placed in the 'sdev_configure' member
 of a "struct scsi_host_template" instance. A pointer to such an instance
-should be passed to the mid level's scsi_host_alloc() [or scsi_register() /
-init_this_scsi_driver()].
+should be passed to the mid level's scsi_host_alloc() or scsi_register().
+.
 
 The interface functions are also described in the include/scsi/scsi_host.h
 file immediately above their definition point in "struct scsi_host_template".
@@ -817,10 +817,6 @@ Details::
     *      The SCSI_IOCTL_PROBE_HOST ioctl yields the string returned by this
     *      function (or struct Scsi_Host::name if this function is not
     *      available).
-    *      In a similar manner, init_this_scsi_driver() outputs to the console
-    *      each host's "info" (or name) for the driver it is registering.
-    *      Also if proc_info() is not supplied, the output of this function
-    *      is used instead.
     *
     *      Optionally defined in: LLD
     **/
