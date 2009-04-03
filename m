From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT data)
Date: Fri, 3 Apr 2009 19:08:41 +0200
Message-ID: <e2e108260904031008u434e6d06rc7d657a087e64fbc@mail.gmail.com>
References: <49D10256.8030307@vlnb.net>
	 <e2e108260904011314h1e0cf5c5wcdf210eee24d40d8@mail.gmail.com>
	 <49D4F2E1.7000507@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53681 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbZDCRIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 13:08:44 -0400
In-Reply-To: <49D4F2E1.7000507@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 2, 2009 at 7:16 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> Bart Van Assche, on 04/02/2009 12:14 AM wrote:
>> I have repeated some of these performance tests for iSCSI over IPoIB
>> (two DDR PCIe 1.0 ConnectX HCA's connected back to back). The results
>> for the buffered I/O test with a block size of 512K (initiator)
>> against a file of 1GB residing on a tmpfs filesystem on the target are
>> as follows:
>>
>> write-test: iSCSI-SCST 243 MB/s; IET 192 MB/s.
>> read-test: iSCSI-SCST 291 MB/s; IET 223 MB/s.
>>
>> And for a block size of 4 KB:
>>
>> write-test: iSCSI-SCST 43 MB/s; IET 42 MB/s.
>> read-test: iSCSI-SCST 288 MB/s; IET 221 MB/s.
>
> Do you have any thoughts why writes are so bad? It shouldn't be so..

It's not impossible that with the 4 KB write test I hit the limits of
the initiator system (Intel E6750 CPU, 2.66 GHz, two cores). Some
statistics I gathered during the 4 KB write test:
Target: CPU load 0.5, 16500 mlx4-comp-0 interrupts per second, same
number of interrupts processed by each core (8250/s).
Initiator: CPU load 1.0, 32850 mlx4-comp-0 interrupts per second, all
interrupts occurred on the same core.

Bart.
