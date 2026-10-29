Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793302293;
	b=EIMKRstAgExjTo273BDTHcQ/c8K1NXtPILXECOVStJNndwFLghVaSdjRl1LqCcOCWEPT
	 CPu53xIRuxcBnVlh1bLzT6V1SN2xb9fVcDhgi/ocLFCUd+4pJdLS8Zu0MMYxifM8TBX1i
	 t3lLc7G54Ha/sJXUILn5T7GtIkTemDknpz0ModHwXsU10XGRgcrYPkpwLvPlPETJpkoPH
	 K1Kyz9H3G0/eCn6hla18s6mp49KuDXRMZuwo7GXJE8vUs4XVHeDkMYEuhUB59P3VnVH5h
	 r4gABUAs3e1sPct7RVR2/xrSaauGoR1qoO8rv+dS/EsndeDBMvYoZkk/AW/h/ayYG1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793302293;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition;
	bh=0pXuLeWnwLuEdTfr5wuCa/0ukD8OinO4VmLvRf/x6AY=;
	b=TkaXnJEEMSX0OgXjmYYM2kk7/w4pNfXQC+jiygQ2XCuJg3sOKsWJy4Qz6Z9mwYDrTEmY
	 pZKeG/fVzkLlwxugi6VW3aXO48dmllMNRw6g/2Z471HKok/hOeEyq8TFpf+HxWBsr5gDT
	 QG2EJeewQ+hT1yvJCu6bDi9Wyj9W4b9nk12PSyVaGgQ0Yb9L6AtWUvlqY0XHsPmiVszZM
	 lSmwqix+gdsWOl1VRoOojjgJr/T8TUP8rxrgx47U3FkqZNL7VdcAawgPzdabUu8Iuixa7
	 yuhNO0M6/F6TLs9mUia9gFF3QYidL6QognJ72EBxEBpHpsjriSHgA87nJTiNXjzCqwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Z/i8Y425";
	arc=none smtp.remote-ip=74.125.224.46
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169B3606A31D
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 19:31:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 169B3606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z/i8Y425
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-67583c777abso1378241d50.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 12:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793302292; x=1793907092; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0pXuLeWnwLuEdTfr5wuCa/0ukD8OinO4VmLvRf/x6AY=;
        b=Z/i8Y425SNmQbAcagV5ZAByEy9jq2mjoztnJcpFrTQ5Bu3Ic9QVDTPQcemCyDAMYcR
         jlWeJ17UGvEHfoq22U3aEtjh8ymc1FEIHDxHcMJI4bNKPxiUP3f+eY35d1PU+Bi1Fhm+
         9YNtNm3xsm4ljmR6AB2XuX4fVCakP+oQAZHKWLBqSIo+FsyCcVP9sT6gK+Dv7BTas8ea
         GMm6b3d6GUqWzg5pqaWRjUBB6kLRPVkvQjgFzNx0P+8n4pvNNrDesc+kxt5giRojrTCr
         /wy2JF3KnCGRITJd2ZH4Va+QrqeSC7ix/CBEYBgvvYE3yaTeISIUa+xjJc7ksz5IKG/R
         b6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793302292; x=1793907092;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0pXuLeWnwLuEdTfr5wuCa/0ukD8OinO4VmLvRf/x6AY=;
        b=eYI3Zs5nstsoOhB1XeFf1eWosdoPlW40kRuZAKre1j4nEA9boNv+yZdjRzORTxmFVY
         ptZ3enhq9E+iTrMGQVLvcyn89jc4P8mQcpIod7QVkVQ6IbAiHkCpd2C0po/Fsz+aNqtY
         a515h2vmuTnA2Hqim/hAc5qOKOnW0u/+c5xdB3BNT7SZKUvIN7JhjBf5rQjYE0c8m3xD
         YsSArBkR7MKONd2cbRJ2jJu16irPi65BA6DyGv8T4h2EiUUruRZ+6n3GDTykhd7EFo6+
         0ENJpGpXBx7rvfWZ/QQ5OBTrIlxdu4G6JO9v9Et8tgugXS31J1gUkcX801v0+nP+xOeH
         ekcg==
X-Forwarded-Encrypted: i=1; AKwUvBxSJpiUeaI7M/5/dhOih14R3wzoX4QLA0kS/62MO3w5sZ30bescDrx0CRw6g6Y4t03/9bBmAGj36xAK@vger.kernel.org
X-Gm-Message-State: AFq9FYIgMdrqUgYtP7q1DkcPAz3dRgmArrdpRa8xC/0EeUeZI1aWRd0W
	YyNXZOUPUPueZuF1PEYEm0aKsosaxuiwaTHhn5pqk6E451cKdeV5H8mD
X-Gm-Gg: AYBFou3oJVmlhU9P7NXgaEMcVqgwp/GVXO5nY2tdkgtrgH0wz84en81CLNWH2+kvWz1
	B4bBr38nkfnpxfF7AKStyrMVU9OEZi4Yn6D6w34WhUTEoOPVG1Nv7j5KHy75GOegJtMVgg+7J7D
	MmtsO/TP2zNgb4cfzR8kdqQs4CNghzcF4eRGJrYMeCWWrXr9/KNTstCZi2WLX/x+yl0UBdNgxeX
	TKzOfKOtAeVnF5gvaFIuImhymftbYEtRUTQUPoooSiKn+YctFSh1naKofBo6ozMKkYeZ0voBSOO
	U9IH6wQf6DqoufFcijuNmNXNfVcvVr/zTmMej6q0BC2658qxKOlBMYVNteUl8eUPPPxhj/+3m3I
	8KHeOubNuHUZ2jFAhVFduTX/xnOGEYwesSRz0to2ZXuFroQZTVUK+aIgslmbUo0Z7oFNitleYIz
	sqIzeUByMI5CWqT8IUEwMCmZ8/x97DHgN9gpSp1JU7WLZGWPe54ob5ihvxiXC+s44lUjoZuP4m2
	AZQuM+jE+Fp5Hx/ok+zVzah4SlBv7ezx/E9ZbkhJrGXBfPyAJV0lRs7UVnq6/jlsNSq1GOkMDJf
	iZvS/aeTLV23aDKzYwA2lR2q8gq1IVpfSeFgelIVpkyNFPCdh7UiWNHjWw==
X-Received: by 2002:a05:690e:118a:b0:679:9e81:e523 with SMTP id 956f58d0204a3-67a8d05799dmr2459364d50.5.1793302291619;
        Thu, 29 Oct 2026 12:31:31 -0700 (PDT)
Received: from daniel-HP-Stream-Laptop-14 ([2607:fb90:ef13:305:4486:2d08:e87c:8ba9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b4b2f81asm794187b3.30.2026.10.29.12.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 12:31:31 -0700 (PDT)
Date: Thu, 29 Oct 2026 15:31:24 -0400
From: Daniel West <daniel.west.dev@gmail.com>
To: Hannes Reinecke <hare@suse.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: scsi: aic7xxx: spelling corrections in comments
Message-ID: <auOfDNDXtYlhsXt0@daniel-HP-Stream-Laptop-14>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Fixed multiple speeling errors in the comments.

Signed-off-by: Daniel West <daniel.west.dev@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index 20857c213c72..39352ffaba7e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -432,9 +432,9 @@ struct hardware_scb {
  * each S/G element is expired, its datacnt field is checked to see
  * if the LAST_SEG flag is set.  If so, SG_LIST_NULL is set in the
  * residual sg ptr and the transfer is considered complete.  If the
- * sequencer determines that there is a residual in the tranfer, it
+ * sequencer determines that there is a residual in the transfer, it
  * will set the SG_RESID_VALID flag in sgptr and dma the scb back into
- * host memory.  To sumarize:
+ * host memory.  To summarize:
  *
  * Sequencer:
  *	o A residual has occurred if SG_FULL_RESID is set in sgptr,
@@ -499,7 +499,7 @@ struct hardware_scb {
  * the length to store additional address bits and a flag to indicate
  * that a given segment terminates the transfer.  This gives us an
  * addressable range of 512GB on machines with 64bit PCI or with chips
- * that can support dual address cycles on 32bit PCI busses.
+ * that can support dual address cycles on 32bit PCI buses.
  */
 struct ahc_dma_seg {
 	uint32_t	addr;
@@ -741,7 +741,7 @@ struct ahc_syncrate {
 #define	AHC_ULTRA2_XFER_PERIOD 0x0a
 
 /*
- * Indexes into our table of syncronous transfer rates.
+ * Indexes into our table of synchronous transfer rates.
  */
 #define AHC_SYNCRATE_DT		0
 #define AHC_SYNCRATE_ULTRA2	1
@@ -970,7 +970,7 @@ struct ahc_softc {
 
 	/*
 	 * Device instance currently on the bus awaiting a continue TIO
-	 * for a command that was not given the disconnect priveledge.
+	 * for a command that was not given the disconnect privilege.
 	 */
 	struct ahc_tmode_lstate  *pending_device;
 
-- 
2.51.0

