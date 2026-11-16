Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794861637;
	b=zWrPR0bB4aGmdQY4x9e3gcVsHIbUZwNRdBYZK03G9tytsDUY8NlbttsftI3mzHPg5J5z
	 n//gKRwscW0W4IRBRUHJKbWH86GvrjvVin2X8nunti6BG3eIDbzpii9t3YgX9M827qI4X
	 jCS366Aw7Pb6aWY4+JN8Nc3TFm/cEpTgtcYBE0rOsBgo3PaVjxICHtQwRVL653HQujWgy
	 JKXz+kVCyH/as0n4a+xjjPSjVMRwqTo9uBIU8DUptBhgzvW2grlmocHoa5Ld0GvnieeE/
	 Nyv8DE1U97li8tPq94nFgKHSDjkRtmNsuWAzSvETLlMej/4szuW9KZPqSgKpfXW4JyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794861637;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Xg2btas9JyYmnDhG3LhoG22Z+VYl331ZNWxM0LG1Vaw=;
	b=xvp+oFHFG1Y/iblDZEDbHnsDhuSJ0jhHEZy3fywe9dIDB9GW/dy9KTKBkfvfjBc5U38r
	 SyMKeKSae+4gii3Y8aeiBAE/hfxj8G2t5tDltMYhtpDxggAj3VOD2plPboacxX2AhQnej
	 vxIQv1frtlYt/O0ym+kSe33cxZOebOSKGORvMyoAp08lOxysbKM/g/Bb3x0WIOWRwvY8d
	 Q2QjyAt76GBFTRneBtHZz5r/tz0xzvDg+zRRmmOaB8YpIKRzQjWpd2ORPbWoxP6A/ZiJd
	 ZWhAEwrW0UvfPbDmijgQngOI6ZYnLtphyZBRWci7IP3E1d2+Nmt+uAL7NSSF4qNFgMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MCQ6bmiU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33B5606A31C;
	Mon, 16 Nov 2026 20:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MCQ6bmiU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247561F000C4;
	Mon, 16 Nov 2026 20:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794861637;
	bh=Xg2btas9JyYmnDhG3LhoG22Z+VYl331ZNWxM0LG1Vaw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MCQ6bmiUPvLO+3GVsHl8hNZC9eshDxtZq1wsph0qLhLFEEcLW3be1slOiIMxlxD02
	 zSoak9ba84YN05gZLGYcOF13KfxZgqIzyURCXI6lmaFhfc4+gqDLi48j7/K1wbAD6S
	 rY7An7h7WXcvz7X+W5fWWEmRDt4mSSWllABx6172Uup5d0Bsf7/8XYwsRkPuTFkNIC
	 56Rfk9QmwBiLI5eLww4EAYWz4LpNuJ8sjR221k4baLv5IjoltLBbLOlvIs78v/bRQV
	 amQOh8z5Im3/Xz2AW9IX98S9yAtAF3KTo8NYyMrLvPLD9EDndE9EKmidoKYQuhDN35
	 /TwacoJt2NOSw==
Message-ID: <037b2eab-65a0-439a-814b-cc653e8cc629@kernel.org>
Date: Mon, 16 Nov 2026 12:40:36 -0800
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
Subject: Re: [PATCH] scsi: scsi_ioctl: require write access for the
 depopulation commands
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: stable@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20261116183139.2878673-2-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261116183139.2878673-2-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/16/26 10:31, Niklas Cassel wrote:
> scsi_cmd_allowed() lets anybody who can open a SCSI device, even
> read-only, send any SERVICE ACTION IN(16) command. Besides READ
> CAPACITY(16) and the other read-only service actions, that opcode also
> carries the storage element depopulation commands of SBC-4: REMOVE
> ELEMENT AND TRUNCATE, RESTORE ELEMENTS AND REBUILD and REMOVE ELEMENT
> AND MODIFY ZONES. These change the capacity of the device, and after
> REMOVE ELEMENT AND TRUNCATE the contents of the user data area may have
> no relation to what they were before.

Since that is basically reformatting the drive, I thing we can say that the
content is likely gone...

> SCSI devices that support depopulation execute these commands directly,
> and libata translates them to the equivalent ATA commands, so a user
> with read-only access to the device node can truncate the device through
> SG_IO, SCSI_IOCTL_SEND_COMMAND or bsg.
> 
> Treat these service actions like FORMAT UNIT and ERASE, which also
> destroy data, and only allow them if the device is opened for writing.
> The other SERVICE ACTION IN(16) service actions remain allowed for
> everybody who can open the device.
> 
> Cc: stable@vger.kernel.org

Hmmm... SAI_REMOVE_ELEMENT_AND_TRUNCATE and friends was defined with
2a0adbb80a2f ("scsi: define depopulation capabilities related service actions"),
which is in 7.3 only.

So maybe make that

Cc: stable@vger.kernel.org #7.3

?

Or maybe simply add:

Fixes: db496721cb0d ("ata: libata-scsi: add support for the REMOVE ELEMENT AND
TRUNCATE command")
Fixes: 1e307ca61a9c ("ata: libata-scsi: add support for the RESTORE ELEMENTS AND
REBUILD command")
Fixes: b448bb42bd10 ("ata: libata-scsi: add support for the REMOVE ELEMENT AND
MODIFY ZONES command")

> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Otherwise looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
