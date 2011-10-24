From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/9] ib_srpt: Fix sport->port_guid formatting code
Date: Mon, 24 Oct 2011 13:25:52 -0700
Message-ID: <1319487952.17450.72.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-6-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-pcNWgt1uxT2gH6KvDhdkkP1hbBbYnt81f-gHVr_UhdBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-pcNWgt1uxT2gH6KvDhdkkP1hbBbYnt81f-gHVr_UhdBg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-24 at 21:57 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > +               snprintf(sport->port_guid, sizeof(sport->port_guid),
> > +                               "0x0000000000000000%016llx",
> > +                               be64_to_cpu(sport->gid.global.interface_id));
> 
> If I interpret Roland's e-mail correctly Roland asked to use GID table
> entry 0 (http://www.spinics.net/lists/linux-rdma/msg09751.html) ?
> 

I'll defer to Roland on this, as the port->gid.global.interface_id you
recommended does exactly what we need.  I'm happy to test another code
snippet if you have one handy.

--nab
