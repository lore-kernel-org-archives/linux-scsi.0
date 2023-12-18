Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C6F14AB0
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 10:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rr/f+y+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A504C433C7;
	Mon, 18 Dec 2023 10:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702895391;
	bh=qJCRDJkKEEQY7L81XwGrSSmzNrJGdMQVTrEZYd8t1BQ=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=rr/f+y+djGB6waepTSFH1I0OH6BdGgBR0bvSMW+AISssalKEsXVTuwm5GNiBpOWQX
	 b5jegazI5gn5jz6ZD+S8DAY6Zkq+oVPN6FYlRTUNr/xqXkan65NrP0sSrt2i0Glu61
	 glIsdgSKGtYH8EAA3SmozqYDwVJYc9He5R3R77sZd/1g0waKGz6N3YsdaHAQl00aOi
	 BzYcaJtbG0dXY9NRtSnVGo30dxrIVglFyEzjEkoBjRcm/pmJ6eP8qthh8dXAB9bcDD
	 4dn8XFlCbxOzg0pB7U9T8c9NdXSNGaM52RLw7LDrrdwvBQkLoVM0P288GUylvf84Kz
	 pmxa9n13W/xrQ==
Message-ID: <4824e87d-c9f5-41d7-ba14-bbeb8ea0c3f0@kernel.org>
Date: Mon, 18 Dec 2023 19:29:49 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Content-Language: en-US
To: bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org
References: <bug-218198-11613@https.bugzilla.kernel.org/>
 <bug-218198-11613-72JcrIjRZb@https.bugzilla.kernel.org/>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <bug-218198-11613-72JcrIjRZb@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2023/12/18 19:18, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218198
> 
> --- Comment #19 from Dieter Mummenschanz (dmummenschanz@web.de) ---
> Hallo Niklas,
> 
> thanks for getting back to me on that.
> 
>> Please consider writing to the libata mailing list instead of using
>> bugzilla, I'm quite sure that you will get more eyes on your problem
>> that way.
> 
> Could point me to that mailing list please. I can't seem to find it. Do you
> want me to repost the issue there or is it okay to just copy & past the
> messages from this bug?

For any subsystem, you can see the emails to use by running:

scripts/get_maintainer.pl

So for ATA:

scripts/get_maintainer.pl drivers/ata/
Damien Le Moal <dlemoal@kernel.org> (maintainer:LIBATA SUBSYSTEM (Serial and
Parallel ATA drivers))
linux-ide@vger.kernel.org (open list:LIBATA SUBSYSTEM (Serial and Parallel ATA
drivers))
linux-kernel@vger.kernel.org (open list)

Given the high traffic, no need to add linux-kernel@vger.kernel.org. But please
add linux-ide@vger.kernel.org to the bugzilla case.

And also please add Niklas and myself.

Niklas Cassel <Niklas.Cassel@wdc.com>
Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

