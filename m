From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Thu, 21 Jul 2016 13:40:25 -0700
Message-ID: <db1c2fb9-c1c2-f73d-3e66-c275218e42c1@sandisk.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
 <20160720140815.GA19045@redhat.com> <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
 <20160721203209.GB27509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0066.outbound.protection.outlook.com ([104.47.42.66]:7817
	"EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753877AbcGUUkg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2016 16:40:36 -0400
In-Reply-To: <20160721203209.GB27509@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On 07/21/2016 01:32 PM, Mike Snitzer wrote:
> BTW, curious, how is it that you're simulating the cable pull?  I'd like
> to see if doing the same, via a new test in mptest, exposes this issue
> you're hitting.

Hello Mike,

Writing into the /sys/class/srp_remote_ports/port-*/delete sysfs 
attribute causes the SRP initiator driver to call scsi_remove_host(), 
what also happens if the dev_loss_tmo timer expires.

Bart.
