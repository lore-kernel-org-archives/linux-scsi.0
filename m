From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/8] tcm_loop updates
Date: Mon, 06 Jul 2015 23:26:47 -0700
Message-ID: <1436250407.23883.25.camel@haakon3.risingtidesystems.com>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
	 <20150619064855.GB1183@lst.de> <5583C117.4030103@suse.de>
	 <1435048143.7460.50.camel@haakon3.risingtidesystems.com>
	 <55892164.6020907@suse.de>
	 <1436228703.5138.2.camel@haakon3.risingtidesystems.com>
	 <559B6893.5030604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <559B6893.5030604@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-07-07 at 07:50 +0200, Hannes Reinecke wrote:
> On 07/07/2015 02:25 AM, Nicholas A. Bellinger wrote:
> > On Tue, 2015-06-23 at 11:05 +0200, Hannes Reinecke wrote:
> >> On 06/23/2015 10:29 AM, Nicholas A. Bellinger wrote:

<SNIP>

> >>> How different do you expect sas, fc, and iscsi transports to be..?
> >>>
> >>> Do you think this would this be better served by a simple tcm_loop LLD
> >>> specific API for different multipath transports..?
> >>>
> >> Actually, I would split off the various transport functions into
> >> separate files (tcm_loop_sas, tcm_loop_fc, etc), but keep a common
> >> tcm_loop module.
> >> We can even make transport classes optional by adding an explicit
> >> 'sas.XXX' prefix scanning when creating the device similar to what
> >> we do with the 'fc.XXX' prefix already.
> >> With that we would have a 'sas.XXX', 'fc.XXX', and 'iqn.XXX' WWN
> >> which would attach to the respective transport class, and any other
> >> WWN (which would be the default) would be getting the standard
> >> emulation without any transport class attached.
> > 
> > I'm open to merging the tcm_loop patches #1-#6 as-is for the sas
> > transport pieces, or wait until you've done a large split based on
> > transport class types.
> > 
> > It's really your call how the initial merge should look.
> > 
> Probably leave out the transport class stuff for now; I kinda like
> the idea of having all types of transport classes available for
> tcm_loop.
> But this is actually not related to the rest of the patchset, so
> you can skip those for the time being.
> 

Just to confirm, applying patch #3-#6, and #8 to for-next now.

Skipping #7 for the moment, given host side expectations short of being
configurable as noted by HCH.
