From: Christoph Hellwig <hch@lst.de>
Subject: Re: Re: [PATCH/RFC] IB: Add SCSI RDMA Protocol (SRP)
	initiator
Date: Tue, 1 Nov 2005 06:04:23 +0100
Message-ID: <20051101050423.GA25691@lst.de>
References: <52wtjtk3d1.fsf@cisco.com>
	<20051101110409V.fujita.tomonori@lab.ntt.co.jp>
	<52irvdge6c.fsf@cisco.com> <20051101045800.GA25519@lst.de>
	<52acgpgdso.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <openib-general-bounces@openib.org>
Content-Disposition: inline
In-Reply-To: <52acgpgdso.fsf@cisco.com>
List-Unsubscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=unsubscribe>
List-Archive: <http://openib.org/pipermail/openib-general>
List-Post: <mailto:openib-general@openib.org>
List-Help: <mailto:openib-general-request@openib.org?subject=help>
List-Subscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=subscribe>
Sender: openib-general-bounces@openib.org
Errors-To: openib-general-bounces@openib.org
To: Roland Dreier <rolandd@cisco.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, openib-general@openib.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 31, 2005 at 09:03:35PM -0800, Roland Dreier wrote:
>     Christoph> No. Bitfields for accessing hardware/wire
>     Christoph> datastructures are wrong and will always break in some
>     Christoph> circumstances.  Your header is much better.
> 
> OK, that's my feeling as well.
> 
> Would it make sense for me to split the pure SRP spec structures and
> so on into a separate file and put it in include/scsi/srp.h?  Then we
> can move ibmvscsi towards using that file.

Sounds like a good idea, yes.
