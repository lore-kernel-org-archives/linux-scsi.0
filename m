From: Varun Prakash <varun@chelsio.com>
Subject: Re: [RFC 20/34] iscsi-target: update struct iscsit_transport
 definition
Date: Thu, 18 Feb 2016 18:06:29 +0530
Message-ID: <20160218123627.GA1679@ubuntuvm>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
 <a7968adffc57ab25f06713890159014b3571bc53.1455467089.git.varun@chelsio.com>
 <56C20663.8010405@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56C20663.8010405@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "roland@kernel.org" <roland@kernel.org>, SWise OGC <swise@opengridcomputing.com>, Indranil Choudhury <indranil@chelsio.com>, Karen Xie <kxie@chelsio.com>, Hariprasad S <hariprasad@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 15, 2016 at 10:39:55PM +0530, Sagi Grimberg wrote:
> 
> > 1. void (*iscsit_rx_pdu)(struct iscsi_conn *);
> >     Rx thread uses this for receiving and processing
> >     iSCSI PDU in full feature phase.
> 
> Is iscsit_rx_pdu the best name for this? it sounds like
> a function that would handle A pdu, but it's actually the
> thread function dequeuing pdus correct?

iscsit_rx_pdu is for both dequeuing and processing iscsi pdus,
I will rename it to iscsit_get_rx_pdu in the next revision.
