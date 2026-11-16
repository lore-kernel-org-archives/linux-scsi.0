Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794866859;
	b=mIGUhtPDEz1rAJhoxvj6MQ2v8D5OBQx9rAul+Zr8vBm/0Krx+gzeT6HJd7Ikjj1oRZvL
	 VoJPpOAkjlMpcFWaa0wXDYdXUC8y93yBBY3S1wmgQLtj8dbYgh0G6ca7Lv9s8tMlVG+/m
	 sfd+BtXpFFKm105BW4unLhXjlJh5u+Rckb1nZmiFkU0E+mXfGfjT1M5bAGULtKDrrQ5z6
	 W+ORLDhFK/5gMi9v06HBHs1bSnj0WiCyKnVthPFhjiWZ/+KjfnKuu87jWfO693j1qt8LV
	 UQKAAXZIv+B4E3zf2FeY8lIZSJWiAygeMpDvimQvSdUzwGdqE6tvUTa5SxHEYTIJqiQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794866859;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=bvHNWn/Ypwuuq8M1xLdD8fENdsng8rJJBmTIjt87Kp0=;
	b=bi+ARhyMw/e3KBUSSEVwywwQaXm4YqK+NoH5DaKkiAfQRbw6mYQLG5sjrbCfE6AgqkKZ
	 dkItPOj4vYgt1VTZJ/eZPKu3f6D57kDEer/7J0fRkeohlLaKVKLNiQuLlWxxVJPaSG/0A
	 UmchBH8hcXILuszD9oKNjfMnoPPWGU7QPEYCkbuULaI3a7zOOLjiQWayJkBAQ8WKtla/c
	 9mKUAup58vg/2wUGMjcjlhw5mZK7m0ZPFd7FcuoAJlfAB32DbLJk84b3y/terQDDXdajC
	 3E0nMVUO5Pq4YGeKdBje0tJVsan2KGNxGwfjR6UtDBEUaedtatio5Of900/uyE5ZZRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TkxzOX4a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15F0606A323
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 22:07:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A15F0606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TkxzOX4a
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b71ee00f0dso960a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 14:07:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794866857; cv=none;
        d=google.com; s=arc-20260327;
        b=rhjm8Wk/tTTIdLg3rNGv/WGZHZg2OArhm+Zt67JxqmCc1ZeGZQzgAgcC8BjtIrWswi
         pj7yK9QfSq/R77ipuz4Q5AmdF7EOX8f+m60Ykf/mLQpZScLD8thX4S0dxbc+I707+tlY
         TZ2ZNu169mGhz60LqeWCj/wq8b/cvS345IYXNac5eXEuWJY2C7I6qo0+p7GQWZ8xKX7m
         7QZxd/O3CKbVw//bZdHpRQQ9twjXfEsWa7+ox5ot56qiqSraVPvjZZaea+QKCLvf2gSF
         Pm096lq15YmqCtnSj3YjzBQ+IpOrOBmCr2RchLd5v7UGqk6TmcQfbDbbW3jyMHoutB7A
         xeYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bvHNWn/Ypwuuq8M1xLdD8fENdsng8rJJBmTIjt87Kp0=;
        fh=OVdZZ5XoOc8sbtRm3UnNAIf7X9T9UhsZ2QU7GTzNQHg=;
        b=YgA/b2eWWAPVgZsiV0scgZdggpgtzOolKnZIfWaXSaZcsbtxL9Hr+uXtB05X6bVEYs
         klt4I59zk5wsObgxTUu1NWYr3kqG+X2YPJFjyij3eS9D/r4jVSbXkYHSBlLgXGT8bCuW
         0J2QlYzn1gA9+GPi8LwCjgz3IMlhfJaC6e7cPgN6rx4+NxZWxwkBR1RM9W0o6FYpdmov
         +crRM8kdFHGENKP32HL9eLVoUIzEbaWPwZfIlINAT8Dq06GUEfkPYrT1ti0xdiQFU12v
         NMILFTgQbFYZru7jA4RU+jBEWqZv+HrtrEqiKZHTVI4nKOd7eBv3+mmWHz/ba+eQpk0C
         RANw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794866857; x=1795471657; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bvHNWn/Ypwuuq8M1xLdD8fENdsng8rJJBmTIjt87Kp0=;
        b=TkxzOX4aoiWaACUOFc/kBTx4IkhPC7hWIyIuHNSS9HAldz5HFGU4mwK8+vifExWweO
         yvtGROP/WTYByvnFZch4aqyll7KoCPzVmpJlD9qBWnV36MzoD/Zjs4kl7x1CdAgx0NlM
         oYGaAlntwuY8Ca9LOSaWqL8aKhpyV1wAwFyfU+ztOpypXVEgr4nKcSKmA2Yy/eMoCUg8
         2Pd1lofaBdLsK4LTkzukVrXj6onlR9E0PI619s2nBbUn4TmgtVVPcRxfFHZaimXx4Kpa
         S3zywiWQz/XmsIHwDtbPV9cH7SRNwvSwrFY5vqGRWIIAeWwHhgX9No9VXyRz5mH6Nuft
         TE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794866857; x=1795471657;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bvHNWn/Ypwuuq8M1xLdD8fENdsng8rJJBmTIjt87Kp0=;
        b=GUZEcGdf27ncrwL5tdc2ecvs1AstlD3OEOs4RQwttc5gxF5fK4+xEiBdU+8IwySnlB
         ml2CXOpZoGYfUptHZg5fhpkSuWIFHEcXx3u5pXIogvLGUvvySs2w3aCwmxwzb6mLMg68
         mm79V54WMmeNroZwWEVr2UzRfjKii/gyTaFFy2xhBLsKe258QfYpw0kR39z2X+5lT2o+
         RITZ9hwpAj7EAnViVJxZZ/uXZwUmbKWcPHhaELYoEg5Iz+kxtQP9Jow6OFRmIFZMOA7U
         BF4hcKoLQ6B7gS89n3FAuK3ZKUS36IQAJMGI+VKyZSyhwEsXysQ2rcOLUxuWw4agGZAg
         SkKA==
X-Forwarded-Encrypted: i=1; AL+hErGgjg6oZoCAv+mvIkRLrVMwKZ1Cc6soaVFPzBhvsjoBbld9Alxn6beJspq5RtZLgtQjnHhS07tDMqKO@vger.kernel.org
X-Gm-Message-State: APuU4Z/wwgIxFBZtQt1HFt1sZFfN5ZHucqwpMs8JxpcCNP66rcm+NeVT
	mQVd4pN8KCOsqConuuEPcK1APTa+IHRNI8bPSgjArwTKM97nqftkdwO2MXpFk7YlV8eL50RvJ1k
	udrDNIW+omoIta8C/PTJb9Wx0DrBsXKwNiju8Xo6r
X-Gm-Gg: AYBFou0+gx7cXsI9odXBOFfTL/QcJ1qpuSATgOnNPm997+UQIL7d8nz6r2XJYpv6fRf
	4hqm8wjOan+oVQzztP3OlWjx5j6ueI6s8Mpt111cA3U8rtJvLPTyKD4Jy+5AMnekb6RRI2YzRdv
	XdFI6kB13ihVn0n7x6Q0W+UWEbLaxV3pqhtV+vID784l0IC189SPwteoZ0EgCd7O1Gs7o00LMer
	5i1iJdhKscumwHQYWUvVtEY7oWhEcOAedwdStYiQBYf6iTBmA6a4ILAY8PbD8DrROO3Lc9Q91oh
	Pstdi0Zl8waRoWDKVy83jItDATEIsvmED1yctUxAVI7kiOPIi7VRGOpLlwy8Kmg09FxeiTcndpM
	P8kiYLIgFr0sUbNM4RhcK8ur9nJIiVjZJ508IcBsVfS2SplrRRn37XsrIea6PGrn16Q==
X-Received: by 2002:a05:6402:21d6:b0:6b7:bff7:bbac with SMTP id
 4fb4d7f45d1cf-6b85b5510f7mr20666a12.6.1794866856424; Mon, 16 Nov 2026
 14:07:36 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116020504.4051796-1-chullee@google.com> <9d58cbf3-e0cc-41b8-8958-df8abd505524@acm.org>
In-Reply-To: <9d58cbf3-e0cc-41b8-8958-df8abd505524@acm.org>
From: Daniel Lee <chullee@google.com>
Date: Mon, 16 Nov 2026 14:07:24 -0800
X-Gm-Features: AclHuK9nG0sgRz_IDHuGpKLsvCg91L-4oJRDfBo0bTPftq8WaH6t570Q_2Ba8YM
Message-ID: <CALBjLoCzDbRg9EO=iJir3WqK5bpQZqTbc9X-hoP823oDUDwUeQ@mail.gmail.com>
Subject: Re: [PATCH v3 RESEND] ufs: sysfs: Add WB partial flush mode support
To: Bart Van Assche <bvanassche@acm.org>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	alim.akhtar@samsung.com, avri.altman@sandisk.com, tanghuan@vivo.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 7:02=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 11/15/26 6:05 PM, Daniel Lee wrote:
>  > +What:
> /sys/bus/platform/drivers/ufshcd/*/attributes/wb_partial_flush_mode
>  > +What:               /sys/bus/platform/devices/*.ufs/attributes/wb_par=
tial_flush_mode
>  > +Date:               June 2026
>  > +Contact:    Daniel Lee <chullee@google.com>
>  > +Description:        This entry controls Extended WriteBooster partial=
 flush
> modes.
>  > +
>  > +            =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  > +            "none"   No partial flush
>  > +            "fifo"   FIFO mode
>  > +            "pinned" Pinned mode
>  > +            =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  > +
>  > +            The attribute is read-write.
>
> Please update the Date: field across the new ABI entries (June 2026 has
> passed).
>
> Also, please drop the quotes around "none", "fifo", and "pinned" to match
> the other string attributes in this file (such as wb_resize_hint,
> wb_resize_status, and hid/state), since literal quotes are neither emitte=
d
> nor accepted.
>
>  > +Description:        This entry configures the maximum size in Allocat=
ion
> Units reserved for the
>  > +            WriteBooster FIFO Buffer size.
>  > +            The attribute is read-write.
>  > +
>  > +What:               /sys/bus/platform/drivers/ufshcd/*/attributes/wb_=
cur_fifo_size
>  > +What:               /sys/bus/platform/devices/*.ufs/attributes/wb_cur=
_fifo_size
>  > +Date:               June 2026
>  > +Contact:    Daniel Lee <chullee@google.com>
>  > +Description:        This entry shows the current size in Allocation U=
nits
> of the WriteBooster FIFO
>  > +            Buffer size.
>  > +            The attribute is read only.
>
> Minor: please drop the redundant trailing "size" in "WriteBooster FIFO
> Buffer size" in both descriptions above.
>
>  > +What:               /sys/bus/platform/drivers/ufshcd/*/attributes/wb_=
pinned_avail_pct
>  > +What:               /sys/bus/platform/devices/*.ufs/attributes/wb_pin=
ned_avail_pct
>  > +Date:               June 2026
>  > +Contact:    Daniel Lee <chullee@google.com>
>  > +Description:        This entry shows the percentage of available spac=
e
> remaining in the
>  > +            Pinned WriteBooster buffer.
>  > +            The attribute is read-only.
>
> Per JESD220G Table 14.28 (IDN 43h,
> bPinnedWriteBoosterBufferAvailablePercentage),
> this value is reported in 10% granularity (00h: 0%, 01h-09h: 10%-90%,
> 0Ah: 100%), not 0-100%. Please document the 10% granularity so userspace
> does not misinterpret 0x0000000A as 10%.
>
>  > +What:
> /sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_cumulative_write_=
size
>  > +What:
> /sys/bus/platform/devices/*.ufs/attributes/wb_pinned_cumulative_write_siz=
e
>  > +Date:               June 2026
>  > +Contact:    Daniel Lee <chullee@google.com>
>  > +Description:        This entry shows the total cumulative size of dat=
a
> written to the
>  > +            Pinned WriteBooster buffer.
>  > +            The attribute is read-only.
>
> Please state the unit here: per JESD220G Table 14.28 (IDN 44h), this valu=
e
> is in units of 10 MB (and saturates at 0xFFFFFFFF).
>
>  > +What:               /sys/bus/platform/drivers/ufshcd/*/flags/wb_unpin=
_enable
>  > +What:               /sys/bus/platform/devices/*.ufs/flags/wb_unpin_en=
able
>  > +Date:               June 2026
>  > +Contact:    Daniel Lee <chullee@google.com>
>  > +Description:        This entry controls the Pinned WriteBooster unpin
> enable flag (fUnpinEn).
>  > +
>  > +            =3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  > +            0        Unpin Disable: pinned data is not flushed by Wri=
teBooster
>  > +                     Buffer flush operation.
>  > +            1        Unpin Enable: pinned data is flushed by WriteBoo=
ster
>  > +                     Buffer flush operation.
>  > +            =3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  > +
>  > +            The attribute is read-write.
>
> ufs_sysfs_flag_show() emits "false" or "true" via str_true_false(flag),
> not 0 or 1, while ufs_sysfs_flag_store() accepts any kstrtobool() value
> (0/1, false/true, n/y, off/on). Please update this description so it
> accurately reflects what reading returns and what writing accepts.
>
>  >  static inline bool ufshcd_is_wb_flags(enum flag_idn idn)
>  >  {
>  > -    return idn >=3D QUERY_FLAG_IDN_WB_EN &&
>  > -            idn <=3D QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8;
>  > +    return (idn >=3D QUERY_FLAG_IDN_WB_EN &&
>  > +            idn <=3D QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8) ||
>  > +           idn =3D=3D QUERY_FLAG_IDN_WB_UNPIN_EN;
>  > +}
>
> Per JESD220G Table 14.26, fUnpinEn (13h) has Type "D" (device-level,
> addressed with INDEX =3D 00h and SELECTOR =3D 00h per Note 1), unlike fla=
gs
> 0Eh-10h which are "A/LU/0 or D" (Note 4). Including
> QUERY_FLAG_IDN_WB_UNPIN_EN here will send a non-zero INDEX when
> WriteBooster uses an LU-dedicated buffer on a non-zero LUN. Please leave
> ufshcd_is_wb_flags() unchanged.

Thanks for pointing this out.

By the way, the name ufshcd_is_wb_flags() is a bit confusing with the
addition of
Type "D" WB flags and attributes, so it might be good to rename it to
ufshcd_is_lu_wb_flag().

For v4, I will keep the exisiting names as requested.

>
>  >  static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
>  >  {
>  > -    return idn >=3D QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
>  > -            idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
>  > +    return (idn >=3D QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
>  > +            idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE) ||
>  > +           (idn >=3D QUERY_ATTR_IDN_WB_PFM &&
>  > +            idn <=3D QUERY_ATTR_IDN_NON_PINNED_WB_MIN_SIZE);
>  >  }
>
> Same issue here. Per JESD220G Table 14.28:
> - 3Fh (bWriteBoosterBufferPartialFlushMode),
>    42h (dPinnedWriteBoosterBufferCurrentAllocUnits),
>    43h (bPinnedWriteBoosterBufferAvailablePercentage), and
>    44h (dPinnedWriteBoosterCummulativeWrittenSize) are Type "D" (INDEX =
=3D
> 00h).
> - Only 40h, 41h, 45h, and 46h are "A/LU/0 or D" (Note 15).
>
> Please restrict ufshcd_is_wb_attrs() to the LU-indexed attributes
> (1Ch-1Fh, 40h-41h, and 45h-46h).
>
>  > +static ssize_t ufs_sysfs_attr_store(struct device *dev,
>  > +    struct device_attribute *attr, const char *buf, size_t count,
>  > +    enum attr_idn idn)
>  > +{
>  > +    struct ufs_hba *hba =3D dev_get_drvdata(dev);
>  > +    u8 index =3D 0;
>  > +    u32 value;
>  > +    int ret;
>  > +
>  > +    if (kstrtou32(buf, 0, &value))
>  > +            return -EINVAL;
>
> Since ufs_sysfs_attr_show() supports 64-bit attributes via
> ufshcd_is_qword_attr(idn), please either support ufshcd_is_qword_attr(idn=
)
> here as well or guard against it (e.g. WARN_ON_ONCE) so a future
> UFS_ATTRIBUTE_RW() user for a 64-bit attribute cannot silently issue a
> 32-bit query.
>
>  > +    ufshcd_rpm_get_sync(hba);
>  > +    ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>  > +            QUERY_ATTR_IDN_WB_PFM, ufshcd_wb_get_query_index(hba), 0,=
 &value);
>  > +    ufshcd_rpm_put_sync(hba);
>
> Since QUERY_ATTR_IDN_WB_PFM (3Fh) is Type "D" per JESD220G Table 14.28,
> please pass 0 instead of ufshcd_wb_get_query_index(hba) here and in
> wb_partial_flush_mode_store().
>
> Also, unlike wb_resize_hint / wb_resize_status / wb_resize_enable, none o=
f
> the new entries check hba->dev_info.ext_wb_sup
> (wExtendedWriteBoosterSupport:
> BIT(1) for FIFO Partial Flush Mode and BIT(2) for Pinned Partial Flush
> Mode per JESD220G Table 14.4, plus hba->dev_info.b_presrv_uspc_en for
> Pinned mode per Section 13.4.18.7). Should we define those capability bit=
s
> in include/ufs/ufs.h and check them (returning -EOPNOTSUPP or hiding
> unsupported attributes via .is_visible) rather than waking the device and
> issuing unsupported queries on devices without these features?

Agreed. I will define them and return -EOPNOTSUPP when unsupported (matchin=
g
wb_resize_hint / wb_resize_status / wb_resize_enable).

Thanks,
Daniel

>
>  > +    QUERY_ATTR_IDN_PINNED_WB_CUMMULATIVE_WS =3D 0x44,
>
> Please spell this CUMULATIVE (single 'M'), matching the sysfs attribute
> name wb_pinned_cumulative_write_size and JESD220G Section 13.4.18.7.2.
>
> Thanks,
>
> Bart.
