From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: aic79xx and RAID ?
Date: Fri, 02 Dec 2005 01:32:50 +0100
Message-ID: <m3fypcuyml.fsf@merlin.emma.line.org>
References: <20051201102039.GA23336@danisch.de>
	<1133433450.2853.25.camel@laptopd505.fenrus.org>
	<20051201104805.GA3893@danisch.de> <438EE0ED.7000605@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.uni-dortmund.de ([129.217.163.1]:17552 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S932576AbVLBAcz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 19:32:55 -0500
In-Reply-To: <438EE0ED.7000605@pobox.com> (Jeff Garzik's message of "Thu, 01
	Dec 2005 06:39:25 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Hadmut Danisch <hadmut@danisch.de>, Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, rick@linuxmafia.com

Jeff Garzik <jgarzik@pobox.com> writes:

> Hadmut Danisch wrote:
>> A software raid controller?  Never heard of such a beast before. I
>> always thought that there are exactly two ways to do raid, one way is
>> to have it all hidden in the controller, which makes the
>> RAID mirror appear as just a single disk to the kernel, and the other
>> way is to use the kernel software raid (configured with
>> mdadm). I've never heard of a software raid controller, where the
>> kernel must
>> do the work itself. After all, what's the controller's job and
>> why is it called a RAID controller then?
>
> Marketing.
>
> Read http://linux.yyz.us/sata/faq-sata-raid.html

Well... your site doesn't list this "HostRAID" euphemism for software
RAID on SCSI ;-)

Seriously, could you add ICH7-R to your fakeraid list, too?
It appears to be software RAID, too.
And perhaps a link to <http://linuxmafia.com/faq/Hardware/sata.html>.

-- 
Matthias Andree
