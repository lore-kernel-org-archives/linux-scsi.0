Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDF6C15B;
	Sun, 14 Jul 2024 22:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720996671; cv=none; b=AWnjZp7OfX4hXDQiWc//4LbSRH4KO6Hy8B1jxVqFngJaFywSZMqBQaZyBEzQyT/FI4ZuYKKDe3EgpBBWhZyyNn8f98r7WenG1PCWX6nNJ6eQMNNWKcZuA+YZ4WjdtlMCoypMNtM9v5NP7sIEWVkE5g1j6kKky7rm0zsUgtnO7Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720996671; c=relaxed/simple;
	bh=9D2oqpvHhIV2K6yX2k+mrEoV3xbBP10wpTitvoSkVM0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kfGLkdQMv72YqN21Ht54m+sY2ItduPd2zxLj2/hbgaIYqQlyNAn4qGhcjMv5xtoUuzubmSkl5iZ5G/tGYB/QTvEW1zI59lcdPuopTJlRUoN9jHgfwuRO/m8gIPoI1dyeX7vBFaGGbqC8RmOGR5ACnXi6nnrStttShfnkxLwCRjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTI8Smkc; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTI8Smkc"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-595856e2336so6125487a12.1;
        Sun, 14 Jul 2024 15:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720996668; x=1721601468; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c5oPaK50hH0OUi4IcBBa3W6X5fDJjIs1X5F+HgvqEM0=;
        b=gTI8SmkcBZJncpL6fl91D99cxo76e3C8ISD/MgiDTmk1+KZjvD831sRQb9V3EEJ3T1
         CatOpwIzVojPGTl4loNQf8PeOJXY5RRhOgcRy6veFeJ1wLj9QZ+iiXDQi0xhJB2cxHhn
         iq+6t5gSFuftu4C3yYlxeBxTwhMD+3OjsLzutEOysnKQKhGQZxFfhIr02WQo8YWQKM0O
         kvZtShSywoUcpOuoZ9Uuoz8fXsj5daIh8zEcVxIV/xW2C9EO6dEMVguqXBfknXuTr+GS
         bWspdoG1wW292uLYFWYhA8VcgKPHSc8r5+mBkHosp0C18HojRDrtPpwhFz1O4FsR3jl1
         vlkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720996668; x=1721601468;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c5oPaK50hH0OUi4IcBBa3W6X5fDJjIs1X5F+HgvqEM0=;
        b=FDGKcdXH1DfVTlSZQdXGyT50y+EMMrf/cPOLaaWumqA+JOSskJMFv4qI/TTfY7MGLh
         exVy0psGTkv4MKcHLdfY7HE7sDnFKyHc0db/2B0Dgc5a7Rp1iCfkmVfxA6xITyCxtTiW
         RziMWp22a7nf5PU6JA45eNAopunXHLAop+vYbH9lmEq5ynwUyxjogVWzFElsJTpsX3FB
         pIuS0PyCwWsxp9WXZZftV8CQ3dA5oWHO1rZN1wisHL2+ZkcWUKYoK41BIwsJuc/uPlsI
         fq7Or/4IrQhUshNUz0DgXflryi4mACOJFZAx+Agfxrqk7Cj9P/oxfmClwUHfpzs8SkEa
         YsIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqFblCXjIBt/qcx1qxgvWnzIS0Xv5K8DDJBBPV+ya55GX+p/QpqrID5LRTIBWUYNxkLJD3O1mElm3sNxB6fvV+ftmhQaUxm2cJ75nQ9cuIRb3Czv038ZWXFesq7QB9JMauYg==
X-Gm-Message-State: AOJu0YwLP+bIXr2586OxxbkbIbNbc2oVQZq5E2ywvviLZN8qXFggCgUX
	Vnbcl1v4g9IvDe0RhfH3pnKLlGzgzmRpxAbPrhpQo9R7I7GBF7Wr
X-Google-Smtp-Source: AGHT+IGfikxf3uYkA3ihL3m7OpjEXdkWnQeJ4rO+cfMqWgLctfm9bTFfdcI/nWgq5Yost4jV8ZqGnA==
X-Received: by 2002:a50:9996:0:b0:57d:6bb:d264 with SMTP id 4fb4d7f45d1cf-59a2427ef62mr6041760a12.1.1720996667868;
        Sun, 14 Jul 2024 15:37:47 -0700 (PDT)
Received: from p200300c58740f7b922c5ae1bb80e710f.dip0.t-ipconnect.de (p200300c58740f7b922c5ae1bb80e710f.dip0.t-ipconnect.de. [2003:c5:8740:f7b9:22c5:ae1b:b80e:710f])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-59b255261c5sm2646635a12.43.2024.07.14.15.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 15:37:47 -0700 (PDT)
Message-ID: <de8b34e3a4055a545de4f6ee4321f968ccbfa0aa.camel@gmail.com>
Subject: Re: [PATCH v1] ufs: core: fix deadlock when rtc update
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, peter.wang@mediatek.com, 
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 avri.altman@wdc.com,  alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, 
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com, 
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 powen.kao@mediatek.com,  qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com,  eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 chu.stanley@gmail.com,  beanhuo@micron.com, stable@vger.kernel.org
Date: Mon, 15 Jul 2024 00:37:45 +0200
In-Reply-To: <d1d20f65-faa9-414f-b7fb-4b53794c0acb@acm.org>
References: <20240712094355.21572-1-peter.wang@mediatek.com>
	 <d1d20f65-faa9-414f-b7fb-4b53794c0acb@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-07-12 at 10:34 -0700, Bart Van Assche wrote:
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Update RTC only when the=
re are no requests in progress
> > and UFSHCI is operational */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!ufshcd_is_ufs_dev_busy(=
hba) && hba->ufshcd_state =3D=3D
> > UFSHCD_STATE_OPERATIONAL)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Update RTC only whe=
n
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * 1. there are no req=
uests in progress
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * 2. UFSHCI is operat=
ional
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * 3. pm operation is =
not in progress
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!ufshcd_is_ufs_dev_busy(=
hba) &&
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba->ufsh=
cd_state =3D=3D UFSHCD_STATE_OPERATIONAL &&
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !hba->pm_=
op_in_progress)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_update_rtc(hba);
> > =C2=A0=C2=A0=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ufshcd_is_ufs_dev_a=
ctive(hba) && hba-
> > >dev_info.rtc_update_period)
>=20
> The above seems racy to me. I don't think there is any mechanism that
> prevents that hba->pm_op_in_progress is set after it has been checked
> and before ufshcd_update_rtc() is called. Has it been considered to
> add
> an ufshcd_rpm_get_sync_nowait() call before the hba-
> >pm_op_in_progress
> check and a ufshcd_rpm_put_sync() call after the ufshcd_update_rtc()
> call?
>=20
> Thanks,
>=20
> Bart.

Bart,

do you want this:

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-
priv.h
index ce36154ce963..2b74d6329b9d 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -311,6 +311,25 @@ static inline int ufshcd_update_ee_usr_mask(struct
ufs_hba *hba,
                                        &hba->ee_drv_mask, set, clr);
 }
=20
+static inline int ufshcd_rpm_get_sync_nowait(struct ufs_hba *hba)
+{
+       int ret =3D 0;
+       struct device *dev =3D &hba->ufs_device_wlun->sdev_gendev;
+
+       pm_runtime_get_noresume(dev);
+
+       /* Check if the device is already active */
+       if (pm_runtime_active(dev))
+               return 0;
+
+       /* Attempt to resume the device without blocking */
+       ret =3D pm_request_resume(dev);
+       if (ret < 0)
+               pm_runtime_put_noidle(dev);
+
+       return ret;
+}
+
 static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
 {
        return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bea00e069e9a..1b7fc4ce9e5c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8209,10 +8209,8 @@ static void ufshcd_update_rtc(struct ufs_hba
*hba)
         */
        val =3D ts64.tv_sec - hba->dev_info.rtc_time_baseline;
=20
-       ufshcd_rpm_get_sync(hba);
        err =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
QUERY_ATTR_IDN_SECONDS_PASSED,
                                0, 0, &val);
-       ufshcd_rpm_put_sync(hba);
=20
        if (err)
                dev_err(hba->dev, "%s: Failed to update rtc %d\n",
__func__, err);
@@ -8226,10 +8224,14 @@ static void ufshcd_rtc_work(struct work_struct
*work)
=20
        hba =3D container_of(to_delayed_work(work), struct ufs_hba,
ufs_rtc_update_work);
=20
+       if (ufshcd_rpm_get_sync_nowait(hba))
+               goto out;
+
         /* Update RTC only when there are no requests in progress and
UFSHCI is operational */
        if (!ufshcd_is_ufs_dev_busy(hba) && hba->ufshcd_state =3D=3D
UFSHCD_STATE_OPERATIONAL)
                ufshcd_update_rtc(hba);
-
+       ufshcd_rpm_put_sync(hba);
+out:
        if (ufshcd_is_ufs_dev_active(hba) && hba-
>dev_info.rtc_update_period)
                schedule_delayed_work(&hba->ufs_rtc_update_work,
                                      msecs_to_jiffies(hba-
>dev_info.rtc_update_period));
(END)




or can we change cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
to cancel_delayed_work(&hba->ufs_rtc_update_work);  ??



kind regards,
Bean
