From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv2 0/7] acpi/libata: Express dependencies for devices on
 dock stations and bays
Date: Sat, 21 Jan 2012 07:55:00 -0600
Message-ID: <1327154100.11421.5.camel@dabdike.int.hansenpartnership.com>
References: <20120120001817.GA27706@homac.suse.de>
	 <20120120002312.GJ27706@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20120120002312.GJ27706@homac.suse.de>
Sender: linux-acpi-owner@vger.kernel.org
To: Holger Macht <holger@homac.de>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-01-20 at 01:23 +0100, Holger Macht wrote:
> On Fr 20. Jan - 01:18:18, Holger Macht wrote:
> > Patches 2 through 5 are just a refresh of the patches from Matthew
> > Garrett sent to this list in September 2010 [1]:
> 
> I successfully faked the sender of the patches from Matthew (now it
> looks as they were sent by him) due to the use wrong use of git
> format-patch. Sorry for that, really wasn't intended. Hope this is not a
> problem.

Actually, it is; the way you sent them the first time:  From: in the
body is the correct way.  If you go about faking the sender, you're
likely to get rejected as spam if people do SPF checking.   Plus it's a
bit confusing for maintainers because I'd really like to know who sent
the patch to verify the signoff chain.

Other than this, it looks fine to me.

James


