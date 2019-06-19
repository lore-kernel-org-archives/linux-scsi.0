From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V5 00/16] use sg helper to operate scatterlist
Date: Wed, 19 Jun 2019 12:43:47 -0700
Message-ID: <3df71d64-78fb-c6fc-f456-a0b626abff3b@acm.org>
References: <20190618013757.22401-1-ming.lei@redhat.com>
 <yq11rzqzacx.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <yq11rzqzacx.fsf@oracle.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, "Juergen E . Fischer" <fischer@norbit.de>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 6/18/19 5:29 PM, Martin K. Petersen wrote:
> I applied this series with a bunch of edits and clarifying comments. It
> was quite the nightmare to rebase 5.3/scsi-queue to satisfy the ordering
> requirements, locate the scattered fixes, tweak tags, etc. Hope I got
> everything right.

Hi Martin,

Do you perhaps plan to push out these patches at a later time? It seems 
like that branch has not been updated recently:

$ git show --format=fuller mkp-scsi/5.3/scsi-queue | head -n7
commit f3e88ad00f58e9a05986be3028b2ed8654c601c9
Author:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
AuthorDate: Fri May 31 08:14:43 2019 -0400
Commit:     Martin K. Petersen <martin.petersen@oracle.com>
CommitDate: Fri Jun 7 10:17:06 2019 -0400

     scsi: mpt3sas: Update driver version to 29.100.00.00

Thanks,

Bart.
