From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH/RFC] IB: Add SCSI RDMA Protocol (SRP)
	initiator
Date: Tue, 01 Nov 2005 11:04:09 +0900
Message-ID: <20051101110409V.fujita.tomonori@lab.ntt.co.jp>
References: <52wtjtk3d1.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <openib-general-bounces@openib.org>
In-Reply-To: <52wtjtk3d1.fsf@cisco.com>
List-Unsubscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=unsubscribe>
List-Archive: <http://openib.org/pipermail/openib-general>
List-Post: <mailto:openib-general@openib.org>
List-Help: <mailto:openib-general-request@openib.org?subject=help>
List-Subscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=subscribe>
Sender: openib-general-bounces@openib.org
Errors-To: openib-general-bounces@openib.org
To: rolandd@cisco.com
Cc: openib-general@openib.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <rolandd@cisco.com>
Subject: [PATCH/RFC] IB: Add SCSI RDMA Protocol (SRP) initiator
Date: Mon, 31 Oct 2005 09:23:06 -0800

> I've posted this several times for review and gotten some (but not
> very much) feedback.  Is there any objection to me asking Linus to
> pull this for 2.6.15?

Any reason the existing SRP definitions (drivers/scsi/ibmvscsi/srp.h)
doesn't work for you?
