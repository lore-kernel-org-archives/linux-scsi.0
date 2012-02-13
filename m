From: Cong Wang <amwang@redhat.com>
Subject: Re: [PATCH 25/60] target: remove the second argument of
 k[un]map_atomic()
Date: Mon, 13 Feb 2012 15:44:15 +0800
Message-ID: <1329119055.2647.35.camel@cr0>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
	 <1328852421-19678-26-git-send-email-amwang@redhat.com>
	 <1328912323.9333.92.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1328912323.9333.92.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>, Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-02-10 at 14:18 -0800, Nicholas A. Bellinger wrote:
> On Fri, 2012-02-10 at 13:39 +0800, Cong Wang wrote:
> > Signed-off-by: Cong Wang <amwang@redhat.com>
> > ---
> >  drivers/target/target_core_transport.c |    4 ++--
> >  drivers/target/tcm_fc/tfc_io.c         |   10 ++++------
> >  2 files changed, 6 insertions(+), 8 deletions(-)
> > 
> 
> Hi Cong,
> 
> This looks fine to me, I assume you'll push this upstream..?
> 
> Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

Hi,

I resent these to let Andrew take them. :)

Thanks!
