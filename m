From: Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH/RFC v2] IB: Add SCSI RDMA Protocol
	(SRP) initiator
Date: Wed, 02 Nov 2005 14:04:41 -0800
Message-ID: <52mzkm905i.fsf@cisco.com>
References: <52r79y91jz.fsf_-_@cisco.com>
	<20051102220358.GA27132@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <openib-general-bounces@openib.org>
In-Reply-To: <20051102220358.GA27132@mellanox.co.il> (Michael S. Tsirkin's
	message of "Thu, 3 Nov 2005 00:03:58 +0200")
List-Unsubscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=unsubscribe>
List-Archive: <http://openib.org/pipermail/openib-general>
List-Post: <mailto:openib-general@openib.org>
List-Help: <mailto:openib-general-request@openib.org?subject=help>
List-Subscribe: <http://openib.org/mailman/listinfo/openib-general>,
	<mailto:openib-general-request@openib.org?subject=subscribe>
Sender: openib-general-bounces@openib.org
Errors-To: openib-general-bounces@openib.org
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: openib-general@openib.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

    Michael> This seems to leak sizeof *attr bytes if
    Michael> ib_find_cached_pkey returns an error.

Good catch.  It actually seems to leak attr unconditionally...
I'll fix it up now.

 - R.
