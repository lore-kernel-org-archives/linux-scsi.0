From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [ofa-general] Re: [PATCH trivial] include linux/mutex.h from
	scsi_transport_iscsi.h
Date: Wed, 25 Jul 2007 13:52:48 -0500
Message-ID: <46A79C00.200@cs.wisc.edu>
References: <20070725110907.GF3826@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <20070725110907.GF3826@mellanox.co.il>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Roland Dreier <rdreier@cisco.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, general@lists.openfabrics.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Michael S. Tsirkin wrote:
> scsi/scsi_transport_iscsi.h uses struct mutex, so while
> linux/mutex.h seems to be pulled in indirectly
> by one of the headers it includes, the right thing
> is to include linux/mutex.h directly.
> 

Is that part about always including the header directly right? If so 
then were you going to include list.h too, and were you going to fix up 
some of the other iscsi code?
