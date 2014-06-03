From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Convert to percpu_ida session tag
 pre-allocation
Date: Mon, 02 Jun 2014 17:09:33 -0700
Message-ID: <1401754173.32085.20.camel@haakon3.risingtidesystems.com>
References: <1400892216-9784-1-git-send-email-nab@daterainc.com>
	 <1400898802.6476.25.camel@haakon3.risingtidesystems.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46D0994E@avmb2.qlogic.org>
	 <1401747155.32085.19.camel@haakon3.risingtidesystems.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46D18873@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <504EB66DAC8D234EB8E8560985C2D7AD46D18873@avmb2.qlogic.org>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-06-02 at 23:32 +0000, Quinn Tran wrote:
> Regards,
> Quinn Tran
> 
> 
> 
> 
> On 6/2/14 3:12 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> >>
> >>Extra size note, the true value should be extracted from
> >>"ha->fw_xcb_count", if this field is set.  Otherwise, default back to
> >>TCM_QLA2XXX_DEFAULT_TAGS.
> >
> >Ok, squashing the following patch into the original to use
> >ha->fw_xcb_count (if available) for determining the worst-case per
> >session number of tags.  Note this currently ends up being ~1.7 MB of
> >pre-allocated descriptors per session.
> 
> QT>  Ack.
> 
> >
> >Also, I assume the pad is required for ha->fw_xcb_count as well..  In
> >that case, the patch below also adds a extra define for 40 extra tags
> >following your pad comment above.
> 
> QT> Pad is not required if the value is read from ha->fw_xcb_count.
> 

Fixed.

Thanks Quinn!

--nab
