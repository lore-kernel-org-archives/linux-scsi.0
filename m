Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18733283CAF
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 15:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001493; cv=none; b=n4d0b32AyWOhg955c3EQoJbjAa3V4BCxJsiOEb0kr6uNbrfd/ZaJt4M2T6Hk4/NcCzrBpYKS56wI2ZbuGNeeQ0tEe2lGd0LiTQycL9pXDbQTpxbRSe1FAIx13Q0qOEupykg4F+NGxEg+/f64Cj5qwLZRk7lv4hmZhW4VFa2UCN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001493; c=relaxed/simple;
	bh=GNG4T3IyxV5t7L2kGCETdYPeAjNlEABauKY6n8jzG+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bP61DZpBIXcn2e+90ifdeDO8kr4X0GW+14SRfCweel3q7LKoJK/Le4RlAHAPgA18LUUN3awtut/J8UaeJgkKW276FCrXFZjITDWh+o25bKojPe1aI+oTPi0M9iSpW1EyGkTQajWAWbHCfQtw6T3DjOH7v2cQ6AY2SVktmmkkBTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=hhPJQJUb; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="hhPJQJUb"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id uBdpuG5pUv724uCLduTuV6; Thu, 04 Sep 2025 15:58:05 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id uCLbuJzviLCV7uCLcuYTFS; Thu, 04 Sep 2025 15:58:04 +0000
X-Authority-Analysis: v=2.4 cv=Zo/tK87G c=1 sm=1 tr=0 ts=68b9b70c
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=XW3vq5T86JFyMsJaYQInbg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=eB5EMIHYC3Eq57A48okA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wsIKJrAXhneWuMZ2Gt5XlAPUdaDAASZmisxqElG8+oQ=; b=hhPJQJUbqWpm4rtoZOzyNG+Z/b
	UyybaI54eqVOgcHhq2gzHJ9K/F1Sp0ZSMtJeLph/h02IiAL5BheyN44ON3CZyz1/ImlLcRaSHK9n9
	kri01p5tpqcmwwh7oAUfbjhvshDTWw/IMrWQBsrLNYP7vZHqy3fisV1DeIyMDb3596/ZOjcUa34M9
	BSEL6vJnbdPNyOngVysO8h4wF/O88JvLRaYwXN+BgGNsnc/DcxctVP3eRWuA/WARbEoYuqwteD1Np
	cDJrT/rXjKj1lEzAmLKixKQju5S76/cvOyBwrXLt0CqxmJuHhnxrm3pzaulfyenpmLokFCA+GzHvx
	mupQRlNQ==;
Received: from d4b26982.static.ziggozakelijk.nl ([212.178.105.130]:52332 helo=[10.52.79.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1uuCLb-00000003O4a-0yLR;
	Thu, 04 Sep 2025 10:58:03 -0500
Message-ID: <5417cc2c-c29a-49f5-8932-44d0507c0dea@embeddedor.com>
Date: Thu, 4 Sep 2025 17:57:53 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: pm80xx: Avoid -Wflex-array-member-not-at-end
 warning
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 John Garry <john.g.garry@oracle.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Jack Wang <jinpu.wang@cloud.ionos.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aLiMoNzLs1_bu4eJ@kspp>
 <7b60681e-a964-494a-a6fa-aba00086b7f7@oracle.com>
 <b79c69e27b4ccd9556c89a88bf6c69ed441193ea.camel@HansenPartnership.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <b79c69e27b4ccd9556c89a88bf6c69ed441193ea.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 212.178.105.130
X-Source-L: No
X-Exim-ID: 1uuCLb-00000003O4a-0yLR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: d4b26982.static.ziggozakelijk.nl ([10.52.79.44]) [212.178.105.130]:52332
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfE8j1XVDIvoPmGwS9Ygd1393X+vZuLhba6Gr/6mn5G0IfJM0Qii5w+a2lr9n4QP0eTWDYygqRTaNLTGwo56/e8v18RT1TbR9O6f6NV4tYUX1LB3MOZ7d
 5hG75XL0sp4blCectN2lQ99lYu/ixK73rYcjzBFAm4+LaC1mxnLcmreet8/xz6Opqrbz+46q3tbl/S4g1uBJe7WqMKn0wSuH2ErgjmYCj7Tc8s8sxPGJ9jwe



On 9/4/25 14:39, James Bottomley wrote:
> On Thu, 2025-09-04 at 07:52 +0100, John Garry wrote:
>> On 03/09/2025 19:44, Gustavo A. R. Silva wrote:
>>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h
>>> b/drivers/scsi/pm8001/pm8001_hwi.h
>>> index fc2127dcb58d..7dc7870a8f86 100644
>>> --- a/drivers/scsi/pm8001/pm8001_hwi.h
>>> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
>>> @@ -339,8 +339,10 @@ struct ssp_completion_resp {
>>>    	__le32	status;
>>>    	__le32	param;
>>>    	__le32	ssptag_rescv_rescpad;
>>> -	struct ssp_response_iu  ssp_resp_iu;
>>>    	__le32	residual_count;
>>> +
>>> +	/* Must be last --ends in a flexible-array member. */
>>> +	struct ssp_response_iu  ssp_resp_iu;
>>
>> this is a HW structure, right? I did not think that it is ok to
>> simply re-order them...
> 
> Agreed, this is a standards defined information unit corresponding to
> an on the wire data structure.  The patch is clearly wrong.
> 
> That being said, the three things the flexible member can contain are
> no data, response data or sense data.  None of them has a residual
> count at the beginning and, indeed, this field is never referred to in
> the driver, so it looks like it can simply be deleted to fix the
> warning.

I see. I just submitted v2. Thanks!

> 
> That being said, this pattern of adding fields after flexible members
> to represent data that's common to all content types of the union is
> not unknown in SCSI so if you want to enable this warning, what are we
> supposed to do when we encounter a genuine use case?

It depends on the situation. Some people prefer to have a separate struct
with only the header part of the flexible structure --this is excluding
the flexible-array member (FAM), and then use an object of that header
type embedded anywhere in any other struct. This of course (sometimes)
implies having to do many other changes to accommodate the rest of the
code accordingly, as in this[1] case.

To address the situation described above without necessarily having to
create a separate header struct and change a lot of code, the
struct_group() helper can be used [2].

In other cases, when for some reason the FAM has to be accessed through
a composite struct, both struct_group() and container_of() (this to
retrieve a pointer to the flexible structure and then access the FAM)
can be used [3].

We have the new TRAILING_OVERLAP() helper that in many cases can be
superior to the struct_group()/container_of() approach. For instance
this[4] could've been fixed with the following shorter and simpler
patch:

  struct nfsacl_simple_acl {
-       struct posix_acl acl;
-       struct posix_acl_entry ace[4];
+       TRAILING_OVERLAP(struct posix_acl, acl, a_entries,
+               struct posix_acl_entry ace[4];
+       );
  };

However, at the time we didn't have TRAILING_OVERLAP(). Also, this new
macro is helping us to detect alignment issues and correct them [5].
These[6][7] are a couple more example of when and how to use this helper.

We also have the DEFINE_FLEX()/DEFINE_RAW_FLEX() helpers [8][9].

So, again, we can do different things depending on the situation and
maintainer's preferences.

Ideally, FAMs-in-the-middle should be avoided, because it's so easy
for them to open the door to memory corruption bugs[10] (to mention
some).

Thanks
-Gustavo

[1] https://git.kernel.org/linus/d2af710d6d50
[2] https://git.kernel.org/linus/c54979a3abc4
[3] https://git.kernel.org/linus/a7e8997ae18c
[4] https://git.kernel.org/linus/dfd500d89545
[5] https://lore.kernel.org/linux-hardening/aLiYrQGdGmaDTtLF@kspp/
[6] https://git.kernel.org/linus/5e54510a9389
[7] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=8abbbbb588f1
[8] https://git.kernel.org/linus/1d717123bb1a
[9] https://git.kernel.org/linus/34116ec67cc1
[10a] https://git.kernel.org/linus/eea03d18af9c
[10b] https://git.kernel.org/linus/6e4bf018bb04
[10c] https://git.kernel.org/linus/cf44e745048d
[10d] https://git.kernel.org/linus/d761bb01c85b
