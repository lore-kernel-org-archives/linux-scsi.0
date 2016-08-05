From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Fri, 5 Aug 2016 11:42:49 -0700
Message-ID: <73e2aeda-140d-72ab-d295-57f35139ae55@sandisk.com>
References: <20160801175948.GA6685@redhat.com>
 <1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com>
 <20160803004013.GA19956@redhat.com>
 <eb1af921-d874-1f6a-c5d0-12d3cae04256@sandisk.com>
 <20160804161047.GC6989@redhat.com>
 <4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com>
 <20160804235850.GB13132@redhat.com>
 <1649218.8261013.1470359248073.JavaMail.zimbra@redhat.com>
 <1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0056.outbound.protection.outlook.com ([104.47.42.56]:12086
	"EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966029AbcHESm4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 14:42:56 -0400
In-Reply-To: <1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org

On 08/05/2016 04:43 AM, Laurence Oberman wrote:
> Further testing has shown we are still exposed here so more investigation is necessary.
> The above patch seems to help but I still see sporadic cases of errors escaping up the stack.
>
> I expect you will see the same so more work to do here to figure this out.

Hello Laurence,

Unfortunately I also still see sporadic I/O errors when testing 
all-paths-down with CONFIG_DM_MQ_DEFAULT=n (I have not yet tried to 
retest with CONFIG_DM_MQ_DEFAULT=y).

Bart.
