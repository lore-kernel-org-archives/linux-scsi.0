From: Andy Grover <agrover@redhat.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] linux servers as a storage server - what's
 missing?
Date: Thu, 26 Jan 2012 13:52:17 -0800
Message-ID: <4F21CB11.7080205@redhat.com>
References: <4EF2026F.2090506@redhat.com> <20120103142609.2b4d06cb@tlielax.poochiereds.net> <20120124213609.GA12426@fieldses.org> <4F1F3B00.8060603@redhat.com> <4F206543.60309@samba.org> <CAL1RGDWxbYHQdFOxAfEWSxxjQKjQgsPgVAGYrZL4NrsB2apKzw@mail.gmail.com> <4F207DB4.50804@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab2AZVwW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 16:52:22 -0500
In-Reply-To: <4F207DB4.50804@samba.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Christopher R. Hertel" <crh@samba.org>
Cc: Roland Dreier <roland@purestorage.com>, Ric Wheeler <rwheeler@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeremy Allison <jra@samba.org>, Simo Sorce <simo@redhat.com>

On 01/25/2012 02:09 PM, Christopher R. Hertel wrote:
> Roland Dreier wrote:
>> On Wed, Jan 25, 2012 at 12:25 PM, Christopher R. Hertel <crh@samba.org> wrote:
>>> Can we put FibreChannel HBAs in *target* mode into a Linux-based PC and
>>> export LUNs via FibreChannel?
>>>  - Do we support multipath in this configuration?
>>>  - Zoning?  Muli-access LUNs for Clustering?
>>
>> Yes to everything, although the low-level FC driver patches are not
>> quite upstream yet.
> 
> Cool!
> Thanks for the update.
> 
> I assume that the management API for this is similar to or the same as the
> FCoE API?  That would make it easier to produce a consistent look-and-feel
> in whatever end-user management tools a third-party my create.

If you're talking about the kernel target stuff, you need to do the
FCoE-specific setup using the same fcoe tools, and then configure the
kernel target via configfs, so that's probably going to be a little
different.

Regards -- Andy
