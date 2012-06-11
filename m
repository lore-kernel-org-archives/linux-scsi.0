From: James Smart <james.smart@emulex.com>
Subject: Re: scsi: lpfc_scsi: Remove unused variables
Date: Mon, 11 Jun 2012 10:02:34 -0400
Message-ID: <4FD5FA7A.5080906@emulex.com>
References: <4FD0434B.7090405@gentoo.org> <20120607061255.GB3210@burratino> <4FD04854.5010304@gentoo.org> <20120607064224.GD3210@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:50786 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751842Ab2FKOC6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2012 10:02:58 -0400
In-Reply-To: <20120607064224.GD3210@burratino>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Richard Yao <ryao@gentoo.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Richard,

fyi - this error in lpfc was corrected in our 8.3.31 patch set - posted 
back in May:
http://www.spinics.net/lists/linux-scsi/msg59216.html

-- james


On 6/7/2012 2:42 AM, Jonathan Nieder wrote:
> Richard Yao wrote:
>
>> Using -Werror enables us to catch potential runtime issues before they
>> happen.
> You have more trust in GCC and other compilers than I do.
>
> If you'd like some entertainment, then for example see:
>
>   http://gcc.gnu.org/PR52798
>   http://gcc.gnu.org/PR25509
>
> Bugs and misdesigned features do not have to be involved for this to
> be a problem --- all it takes is a gcc upgrade that adds a new
> warning, and suddenly you've turned your existing potential code
> cleanliness improvements into failed builds and lots of wasted time
> for innocent sysadmins.  -Werror is great for development, but using
> it in production turns out to be pretty much always a terrible idea.
>
> Thanks for the chance to vent about this. :)  It's bad, bad, bad.
>
> Ciao,
> Jonathan
>
