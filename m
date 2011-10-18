From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: ib_srpt status
Date: Tue, 18 Oct 2011 08:13:54 +0200
Message-ID: <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com>
References: <20111012092318.GA9405@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111012092318.GA9405@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <rdreier@cisco.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 12, 2011 at 11:23 AM, Christoph Hellwig <hch@lst.de> wrote:
> what is the status of queueing up ib_srpt for mainline? =A0It's a ver=
y
> clean looking driver that was submitted 8 month ago and after an init=
ial
> round of fixes only saw updates for changing core APIs.

The ib_srpt driver was working fine last time I tested it. But with
the current (3.1-rc9) LIO core performing I/O triggers grave memory
corruption and random kernel crashes. Something must have changed in
the LIO core that broke ib_srpt.

Bart.
