From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v3 9/9] iser-target: Add iSCSI Extensions for RDMA (iSER)
 target driver
Date: Thu, 04 Apr 2013 14:59:44 -0700
Message-ID: <1365112784.11833.60.camel@haakon2.linux-iscsi.org>
References: <1365060256-21506-1-git-send-email-nab@linux-iscsi.org>
	 <1365060256-21506-10-git-send-email-nab@linux-iscsi.org>
	 <515D45F6.9040903@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <515D45F6.9040903@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-04-04 at 12:20 +0300, Or Gerlitz wrote:
> On 04/04/2013 10:24, Nicholas A. Bellinger wrote:
> > +
> > +void isert_cq_tx_callback(struct ib_cq *, void *);
> > +void isert_cq_rx_callback(struct ib_cq *, void *);
> > +void isert_free_rx_descriptors(struct isert_conn *);
> any reason not to have these as static functions (same for isert_cq_rx_work)

Nope.  Looking at re-orig now to avoid the use of function prototypes
here, and marking everything as static..

--nab
