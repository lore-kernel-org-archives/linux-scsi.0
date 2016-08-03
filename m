From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Wed, 3 Aug 2016 09:06:17 -0700
Message-ID: <4b015567-0fdb-dbf5-96e2-627e76b48a03@sandisk.com>
References: <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com>
	<20160801175948.GA6685@redhat.com>
	<f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
	<20160801204628.GA94704@redhat.com>
	<8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
	<20160802174533.GA18714@redhat.com>
	<1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com>
	<20160803004013.GA19956@redhat.com>
	<1101234181.7977273.1470188006882.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1101234181.7977273.1470188006882.JavaMail.zimbra@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Laurence Oberman <loberman@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/02/2016 06:33 PM, Laurence Oberman wrote:
> #!/bin/bash
> for i in /sys/class/srp_remote_ports/*
> do
>  echo "Deleting host $i, it will re-connect via srp_daemon"
>  echo 1 > $i/delete
>  sleep 10
> done

Hello Laurence,

Sorry but the above looks wrong to me. There should be a second loop 
around this loop and the sleep statement should be moved from the inner 
loop to the outer loop. The above code logs out one (initiator, target) 
port pair at a time instead of logging out all paths at once.

Bart.
