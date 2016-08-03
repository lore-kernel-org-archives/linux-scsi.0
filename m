From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Wed, 3 Aug 2016 09:55:11 -0700
Message-ID: <eb1af921-d874-1f6a-c5d0-12d3cae04256@sandisk.com>
References: <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com>
	<931235537.7668834.1470060339483.JavaMail.zimbra@redhat.com>
	<1264951811.7684268.1470065187014.JavaMail.zimbra@redhat.com>
	<17da3ab0-233a-2cec-f921-bfd42c953ccc@sandisk.com>
	<20160801175948.GA6685@redhat.com>
	<f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
	<20160801204628.GA94704@redhat.com>
	<8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
	<20160802174533.GA18714@redhat.com>
	<1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com>
	<20160803004013.GA19956@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160803004013.GA19956@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/02/2016 05:40 PM, Mike Snitzer wrote:
> But I asked you to run the v4.7 kernel patches I
> pointed to _without_ any of your debug patches.

I need several patches to fix bugs that are not related to the device 
mapper, e.g. "sched: Avoid that __wait_on_bit_lock() hangs" 
(https://lkml.org/lkml/2016/8/3/289).

Bart.
