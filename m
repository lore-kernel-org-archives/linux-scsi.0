From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] RFC: have dm-mpath use already attached
	scsi_dh
Date: Wed, 22 Apr 2009 18:39:08 +0100
Message-ID: <20090422173907.GC7778@agk.fab.redhat.com>
References: <1240374806-6043-1-git-send-email-michaelc@cs.wisc.edu>
	<49EEE071.9060902@suse.de>
	<1240421544.19442.6.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1240421544.19442.6.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 22, 2009 at 10:32:24AM -0700, Chandra Seetharaman wrote:
> I agree with Hannes, that we should allow multipath to override the
> default attachment, mainly to give control to the user.
> But, I have a small issue with the attached patch. See below.
> I prefer not to detach a previously attached hardware handler, if
> multipath doesn't have any handler associated with the device. Leaving
> it will not do any hard to multipath as the multipath layer would not
> call scsi_dh_activate for the device.
 
On balance, I'm inclined to agree - too many layers of config overlapping
here.

If you agree, would one of you like to submit the patch to dm-devel properly,
with appropriate signoffs and a descriptive patch header?

Alasdair
-- 
agk@redhat.com
