From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/2] be2iscsi: Logging neatening
Date: Sun, 14 Aug 2016 10:29:50 -0700
Message-ID: <1471195790.4075.45.camel@perches.com>
References: <1471107782.3467.28.camel@perches.com>
	 <cover.1471119911.git.joe@perches.com>
	 <BY2PR0201MB18626C631DE6E5D09121608181110@BY2PR0201MB1862.namprd02.prod.outlook.com>
	 <1471191843.4075.39.camel@perches.com>
	 <SN1PR0201MB187015BE4FF2DEF46741A2A481110@SN1PR0201MB1870.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:56736 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752356AbcHNRaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2016 13:30:39 -0400
In-Reply-To: <SN1PR0201MB187015BE4FF2DEF46741A2A481110@SN1PR0201MB1870.namprd02.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Sun, 2016-08-14 at 17:09 +0000, Bart Van Assche wrote:

> My primary concern is how to enable and disable log messages from user 
> space. Many drivers define their own logging macros and export a bitmask 
> that allows to enable and disable logging messages per category. These 
> bitmask control mechanisms are annoying because figuring out what bit 
> controls which message category requires a search through the driver 
> source code. I'd like to see all these custom logging macros disappear 
> and being replaced by a single mechanism. The "dynamic debug" mechanism 
> e.g. is in my opinion much easier to use than the different custom 
> logging mechanisms.

Dynamic debug doesn't have a bitmask function and
still requires looking through the code for lines
and format strings.

I think you are looking for a system wide equivalent
for the ethtool/netif_<level> mechanism.

Nothing like that exists currently.

Some code uses a bitmask/and, other code uses a
level/comparison.

Care to propose something?

