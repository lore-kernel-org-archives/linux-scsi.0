Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794798177;
	b=EhgVN3LpGrQ5u1AROH3eiDMhhApsAyQOLa/ANdnwpOJZ4tn5DhsU/HAN8nbUE1Emxa91
	 FUhSRoHVMbp8D9brJt1Aeu8HmE0uOV2YSb8Te5wMOlcwcN8lP2/6OGX1BXPv/84ryjpw9
	 BUhfKsaLULFbf5XEIJ0speS6e0Pg18PRZ0ro1gieVqgprnG5I+Zx5pwh847gonHCTDL6G
	 bma1ggoKAueL9YtDs0l1IgqVHA0+lvpnYO/KwYz7AP8R2Zg5FaweGU8ABzmTozUTNWq3r
	 C3baP3UuxNXHzxS2JulLTejQOWelSPJ7dUpJgsEyjXbfE917K3q2vvuzOq48iBN9TSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794798177;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=flcTih/K2WqgiJssTA1G/vPVARHnzg0pHJPJ9QxEWS8=;
	b=YolD90/QG3bAK0mwsNO4iI2L0ChEywVx4WWgF3/rx4fI0FhhwdvDi3GymRFuNOACrIrp
	 jb/uB7N4ih5xBWKEPd1MWfgASXupiJoOZLPSOqCym+wz6YJX2VujSU+C9hIETyepDMn8v
	 +Q/0iYJjEaGf/u1CMxL2uEHpwzuxn0gpxzndt/psIbVbqex24/kUqVXfU5taN04Edb6qA
	 jRnx5xb6Ae/JQgi+Ei2woHaN4qsDp9iXRdC9H8rkMEUbeANIBZqq7T/HabNgIvPYNLZFG
	 Mni4ZhIw9f5EYs6oTz5PE36bFLs5EvpfJe5EjuqR8vMCtx1jhxWjGAk+5faEyOjw5Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=SROudtYI;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94E606A88B;
	Mon, 16 Nov 2026 03:02:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E94E606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=SROudtYI
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jSXjR40lRzlffvf;
	Mon, 16 Nov 2026 03:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794798165; x=1797390166; bh=flcTih/K2WqgiJssTA1G/vPV
	ARHnzg0pHJPJ9QxEWS8=; b=SROudtYIVni9pdd/Rqni4CcC27e3YMAKu93tVexV
	J0kVxmCr5b2zUi3eBUnvPm/O+OB18s5dUsj+XiFoH+Zbc7baw8Pl9Lkia+6gwJKo
	ds9o3C4PjuwzDvd7DbVUh/J9JF96Ou6otyXvdeqim4Xq8RV7GyZruP6H9CACDXYH
	rqV3YOuclowlnCrALrwI42lkmbt3zCOtp18T88kBdbrNtjstQvCKoi+wp8ohI3Hc
	gzIuPmFaPECnjyvbl4vLjMcBNw+C9JKdw+FjsfzcDaMey6QeAJ0OJuM5rHAETHa7
	mAKOf7chsMVSiKzifBru7dLDd1DCffE/zKtlMKggzXJN4w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id egfHJzUtrqsg; Mon, 16 Nov 2026 03:02:45 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jSXjK0GtDzlpHwl;
	Mon, 16 Nov 2026 03:02:44 +0000 (UTC)
Message-ID: <9d58cbf3-e0cc-41b8-8958-df8abd505524@acm.org>
Date: Sun, 15 Nov 2026 19:02:43 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 RESEND] ufs: sysfs: Add WB partial flush mode support
To: Daniel Lee <chullee@google.com>, James.Bottomley@hansenpartnership.com,
 martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, avri.altman@sandisk.com, tanghuan@vivo.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261116020504.4051796-1-chullee@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261116020504.4051796-1-chullee@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/26 6:05 PM, Daniel Lee wrote:
 > +What:	 
/sys/bus/platform/drivers/ufshcd/*/attributes/wb_partial_flush_mode
 > +What:		/sys/bus/platform/devices/*.ufs/attributes/wb_partial_flush_mode
 > +Date:		June 2026
 > +Contact:	Daniel Lee <chullee@google.com>
 > +Description:	This entry controls Extended WriteBooster partial flush 
modes.
 > +
 > +		======== ==============================
 > +		"none"   No partial flush
 > +		"fifo"   FIFO mode
 > +		"pinned" Pinned mode
 > +		======== ==============================
 > +
 > +		The attribute is read-write.

Please update the Date: field across the new ABI entries (June 2026 has
passed).

Also, please drop the quotes around "none", "fifo", and "pinned" to match
the other string attributes in this file (such as wb_resize_hint,
wb_resize_status, and hid/state), since literal quotes are neither emitted
nor accepted.

 > +Description:	This entry configures the maximum size in Allocation 
Units reserved for the
 > +		WriteBooster FIFO Buffer size.
 > +		The attribute is read-write.
 > +
 > +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_cur_fifo_size
 > +What:		/sys/bus/platform/devices/*.ufs/attributes/wb_cur_fifo_size
 > +Date:		June 2026
 > +Contact:	Daniel Lee <chullee@google.com>
 > +Description:	This entry shows the current size in Allocation Units 
of the WriteBooster FIFO
 > +		Buffer size.
 > +		The attribute is read only.

Minor: please drop the redundant trailing "size" in "WriteBooster FIFO
Buffer size" in both descriptions above.

 > +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_avail_pct
 > +What:		/sys/bus/platform/devices/*.ufs/attributes/wb_pinned_avail_pct
 > +Date:		June 2026
 > +Contact:	Daniel Lee <chullee@google.com>
 > +Description:	This entry shows the percentage of available space 
remaining in the
 > +		Pinned WriteBooster buffer.
 > +		The attribute is read-only.

Per JESD220G Table 14.28 (IDN 43h, 
bPinnedWriteBoosterBufferAvailablePercentage),
this value is reported in 10% granularity (00h: 0%, 01h-09h: 10%-90%,
0Ah: 100%), not 0-100%. Please document the 10% granularity so userspace
does not misinterpret 0x0000000A as 10%.

 > +What:	 
/sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_cumulative_write_size
 > +What:	 
/sys/bus/platform/devices/*.ufs/attributes/wb_pinned_cumulative_write_size
 > +Date:		June 2026
 > +Contact:	Daniel Lee <chullee@google.com>
 > +Description:	This entry shows the total cumulative size of data 
written to the
 > +		Pinned WriteBooster buffer.
 > +		The attribute is read-only.

Please state the unit here: per JESD220G Table 14.28 (IDN 44h), this value
is in units of 10 MB (and saturates at 0xFFFFFFFF).

 > +What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_unpin_enable
 > +What:		/sys/bus/platform/devices/*.ufs/flags/wb_unpin_enable
 > +Date:		June 2026
 > +Contact:	Daniel Lee <chullee@google.com>
 > +Description:	This entry controls the Pinned WriteBooster unpin 
enable flag (fUnpinEn).
 > +
 > +		====== 
==============================================================
 > +		0        Unpin Disable: pinned data is not flushed by WriteBooster
 > +		         Buffer flush operation.
 > +		1        Unpin Enable: pinned data is flushed by WriteBooster
 > +		         Buffer flush operation.
 > +		====== 
==============================================================
 > +
 > +		The attribute is read-write.

ufs_sysfs_flag_show() emits "false" or "true" via str_true_false(flag),
not 0 or 1, while ufs_sysfs_flag_store() accepts any kstrtobool() value
(0/1, false/true, n/y, off/on). Please update this description so it
accurately reflects what reading returns and what writing accepts.

 >  static inline bool ufshcd_is_wb_flags(enum flag_idn idn)
 >  {
 > -	return idn >= QUERY_FLAG_IDN_WB_EN &&
 > -		idn <= QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8;
 > +	return (idn >= QUERY_FLAG_IDN_WB_EN &&
 > +		idn <= QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8) ||
 > +	       idn == QUERY_FLAG_IDN_WB_UNPIN_EN;
 > +}

Per JESD220G Table 14.26, fUnpinEn (13h) has Type "D" (device-level,
addressed with INDEX = 00h and SELECTOR = 00h per Note 1), unlike flags
0Eh-10h which are "A/LU/0 or D" (Note 4). Including
QUERY_FLAG_IDN_WB_UNPIN_EN here will send a non-zero INDEX when
WriteBooster uses an LU-dedicated buffer on a non-zero LUN. Please leave
ufshcd_is_wb_flags() unchanged.

 >  static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 >  {
 > -	return idn >= QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
 > -		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 > +	return (idn >= QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
 > +		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE) ||
 > +	       (idn >= QUERY_ATTR_IDN_WB_PFM &&
 > +		idn <= QUERY_ATTR_IDN_NON_PINNED_WB_MIN_SIZE);
 >  }

Same issue here. Per JESD220G Table 14.28:
- 3Fh (bWriteBoosterBufferPartialFlushMode),
   42h (dPinnedWriteBoosterBufferCurrentAllocUnits),
   43h (bPinnedWriteBoosterBufferAvailablePercentage), and
   44h (dPinnedWriteBoosterCummulativeWrittenSize) are Type "D" (INDEX = 
00h).
- Only 40h, 41h, 45h, and 46h are "A/LU/0 or D" (Note 15).

Please restrict ufshcd_is_wb_attrs() to the LU-indexed attributes
(1Ch-1Fh, 40h-41h, and 45h-46h).

 > +static ssize_t ufs_sysfs_attr_store(struct device *dev,
 > +	struct device_attribute *attr, const char *buf, size_t count,
 > +	enum attr_idn idn)
 > +{
 > +	struct ufs_hba *hba = dev_get_drvdata(dev);
 > +	u8 index = 0;
 > +	u32 value;
 > +	int ret;
 > +
 > +	if (kstrtou32(buf, 0, &value))
 > +		return -EINVAL;

Since ufs_sysfs_attr_show() supports 64-bit attributes via
ufshcd_is_qword_attr(idn), please either support ufshcd_is_qword_attr(idn)
here as well or guard against it (e.g. WARN_ON_ONCE) so a future
UFS_ATTRIBUTE_RW() user for a 64-bit attribute cannot silently issue a
32-bit query.

 > +	ufshcd_rpm_get_sync(hba);
 > +	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 > +		QUERY_ATTR_IDN_WB_PFM, ufshcd_wb_get_query_index(hba), 0, &value);
 > +	ufshcd_rpm_put_sync(hba);

Since QUERY_ATTR_IDN_WB_PFM (3Fh) is Type "D" per JESD220G Table 14.28,
please pass 0 instead of ufshcd_wb_get_query_index(hba) here and in
wb_partial_flush_mode_store().

Also, unlike wb_resize_hint / wb_resize_status / wb_resize_enable, none of
the new entries check hba->dev_info.ext_wb_sup 
(wExtendedWriteBoosterSupport:
BIT(1) for FIFO Partial Flush Mode and BIT(2) for Pinned Partial Flush
Mode per JESD220G Table 14.4, plus hba->dev_info.b_presrv_uspc_en for
Pinned mode per Section 13.4.18.7). Should we define those capability bits
in include/ufs/ufs.h and check them (returning -EOPNOTSUPP or hiding
unsupported attributes via .is_visible) rather than waking the device and
issuing unsupported queries on devices without these features?

 > +	QUERY_ATTR_IDN_PINNED_WB_CUMMULATIVE_WS	= 0x44,

Please spell this CUMULATIVE (single 'M'), matching the sysfs attribute
name wb_pinned_cumulative_write_size and JESD220G Section 13.4.18.7.2.

Thanks,

Bart.
