From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: Re: [RFC] A SCSI fault injection framework using SystemTap.
Date: Tue, 15 Jan 2008 18:54:06 +0900
Message-ID: <478C82BE.6040100@ce.jp.nec.com>
References: <478C22A9.5000009@ce.jp.nec.com> <20080115033145.GR18741@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080115033145.GR18741@parisc-linux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Jan 15, 2008 at 12:04:09PM +0900, K.Tanaka wrote:
>> I would like to introduce a SCSI fault injection framework using SystemTap.
>>
>> Currently, kernel has Fault-injection framework and Faulty mode for md,
>> which can also be used for testing the error handling. But, they could
>> only produce fixed type of errors stochastically. In order to simulate
>> more realistic scsi disk faults, I have created a  new flexible fault injection
>> framework using SystemTap.
> 
> How does it compare to using scsi_debug, which I believe can do all of
> the above and more?
> 

 Sorry for the lack of explanation.
 The new framework is supposed to be used by a userspace testing tool
 (such as a shell script). For the availability, this framework enables user to
 designate the inode number of the target file on the device to inject faults.
 On accessing the target file through page caches, a fault will be injected.
 Also, user can designate the logical block address as the target position
 of a fault injection.

-- 
---------------------------------------------------------
Kenichi TANAKA    | Open Source Software Platform Development Division
                  | Computers Software Operations Unit, NEC Corporation
                  | k-tanaka@ce.jp.nec.com
