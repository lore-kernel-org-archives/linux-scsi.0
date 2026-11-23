Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.222.135.142
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795434593;
	b=Oruz6xZrcOuTrGE33EbP+y3RFeqwogaoa4NFqqPAtHZs0WddiZJNbjIC6YS+MIk10Bct
	 ixN2KJs/IYU8IsXumzz+5Gpj7F3gGpH4i5PLsdEkEaETxMmN/CYuhMcxYmmCQzYM0bFGx
	 QW0d3/OoYQa5ZWZewPicwIRvDjf9Xt9QAMJfggaWCSEN7yyundLjIUEtBYHTdvPzh59nZ
	 dSsFte9ibD68e8iRM8/9oDM3Pe01VAe2fdHd3bK81jfZ+sKgHco0/psW236llqKnYTFZS
	 2yeFDWjIXuLbXdaXxGnd7ct6S+YBCLWbYexIhjla5M7jEouNtn5vyT6Dyk/Z/RDNfVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795434593;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=3ANwkgC2sS8G+uEOYW1Y++4mpRvPqlTWPTRgPAiSPUQ=;
	b=0+WSaNR42kXjpVYakhDmTVzJ4oUxQtMSjjuOK99hnmc+upgtJ/UiDB1PaoN2SIAyWmtH
	 2faA6rGRdmIjiQTzVxgkJaGXdy35B386NlshD5Iv+qYJovkcrPmwe9N5sd1qU5pnvbSmM
	 aG1kgOla48ytUEG0Ucg46nABYdt/FugWdVqcqwjK6/qPR0Hq1nOqSjA4ZwNcbQl7ncKIg
	 dNjRfFcK+qXSB1O3XCbmKG9/nEUzxQ77M/CfhDRr0GJNgu+cVJN4PhU2AV8GZzMnJ+yJt
	 YFICUO8zaKcVppADJqQGvxO/7r6g0ox93TEchnm5EzqidCN77OjUCJN6nd1OnWL3UTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=o2.pl;
	spf=pass smtp.mailfrom=o2.pl;
	dkim=pass header.d=o2.pl header.i=@o2.pl header.a=rsa-sha256 header.s=s20261001 header.b=fk+9mxf2;
	arc=none smtp.remote-ip=193.222.135.142
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B765606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 11:49:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B765606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=o2.pl header.i=@o2.pl header.a=rsa-sha256 header.s=s20261001 header.b=fk+9mxf2
Received: (wp-smtpd smtp.tlen.pl 19424 invoked from network); 23 Nov 2026 12:49:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=s20261001;
          t=1795434577; bh=3ANwkgC2sS8G+uEOYW1Y++4mpRvPqlTWPTRgPAiSPUQ=;
          h=Subject:To:Cc:From;
          b=fk+9mxf2rY4NLpqNBo53IK+AgsfywjWoXnZ4bMXM78CkuQldCCP5fKoYRLvPAIfXW
           ZRCmZExRAvpbasMELuOWjydwJlYuQ1HgzWbVt0M2eI92bUUMKJQdZZhUMIxYAonygZ
           ybVHHVn6vfaiU0/mJo5pP84Utjn7zjqTJSy2OJVGBzqMjxZ3QcWv5Lh20xtY0vlFSs
           ZEwTpobo6ggdhL/CbwTwjxSNmlU/08CDAEsMnh+y9TY1TIgmu4hfiqnAzuhtJdRwOG
           I5AntUMdy51rtgfDQN9USshlJaebBGe9Q3JXEZ6YuvwIFgk3X5PYnM11KVK/D+rF9Q
           P8Bwg0HBpdFYw==
Received: from [192.168.1.22] (apn-78-30-78-152.dynamic.gprs.plus.pl [78.30.78.152])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <oneukum@suse.com>; 23 Nov 2026 12:49:37 +0100
Message-ID: <fdfa2dc4-9cbb-436c-9fac-213a19d6f86a@o2.pl>
Date: Mon, 23 Nov 2026 12:49:34 +0100
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
Subject: Re: [PATCH 1/2] usb: uas: expose US_FL_NO_ATA_1X in sysfs as
 ata_passthrough_disabled
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20261121155253.4980-1-mat.jonczyk@o2.pl>
 <68f6376d-a0cf-4f87-9cbb-0afb7b8536d4@suse.com>
 <52a233cb-1671-431c-8c14-7757ca947aa5@o2.pl>
 <cef781a8-45db-4540-981d-b38667dcfbb7@suse.com>
Content-Language: en-GB, pl
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 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
 TANkZ3QqXNX2
In-Reply-To: <cef781a8-45db-4540-981d-b38667dcfbb7@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-WP-MailID: 891559ab91dd92db76de60529f426fc0
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000A [oRP0]                               

W dniu 23.11.2026 o 12:41, Oliver Neukum pisze:
>
>
> On 23.11.26 11:48, Mateusz Jończyk wrote:
>> W dniu 23.11.2026 o 09:27, Oliver Neukum pisze:
>
>>  > thank you for handling this. One thing though. This requires putting
>>  > the emit code into every driver. Can we centralize that somehow?
>>
>> Not really, short of moving the handling of the ata_passthrough_disabled
>> attribute into the middle SCSI layer (which would also likely involve
>> moving the whole of US_FL_NO_ATA_1X logic from uas_queuecommand_lck()
>> there). Is this what you mean?
>
> Now that you mention it, shouldn't that be where it ought to be anyway?
> Usually the SCSI layer generates or filters commands, while the LLDD
> determine what command sets a device will accept and reports that.
>
OK, I will prepare a patch series as appropriate and report back.

Greetings,

Mateusz

