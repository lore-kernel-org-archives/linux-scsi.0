From: Roland Dreier <rolandd@cisco.com>
Subject: Re: Re: [PATCH/RFC] IB: Add SCSI RDMA Protocol
	(SRP) initiator
Date: Mon, 31 Oct 2005 21:03:35 -0800
Message-ID: <52acgpgdso.fsf@cisco.com>
References: <52wtjtk3d1.fsf@cisco.com>
	<20051101110409V.fujita.tomonori@lab.ntt.co.jp>
	<52irvdge6c.fsf@cisco.com> <20051101045800.GA25519@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <openib-general-bounces@openib.org>
In-Reply-To: <20051101045800.GA25519@lst.de> (Christoph Hellwig's message of
	"Tue, 1 Nov 2005 05:58:00 +0100")
List-Unsubscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=unsubscribe>
List-Archive: <http://openib.org/pipermail/openib-general>
List-Post: <mailto:openib-general@openib.org>
List-Help: <mailto:openib-general-request@openib.org?subject=help>
List-Subscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=subscribe>
Sender: openib-general-bounces@openib.org
Errors-To: openib-general-bounces@openib.org
To: Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, openib-general@openib.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

    Christoph> No. Bitfields for accessing hardware/wire
    Christoph> datastructures are wrong and will always break in some
    Christoph> circumstances.  Your header is much better.

OK, that's my feeling as well.

Would it make sense for me to split the pure SRP spec structures and
so on into a separate file and put it in include/scsi/srp.h?  Then we
can move ibmvscsi towards using that file.

 - R.
