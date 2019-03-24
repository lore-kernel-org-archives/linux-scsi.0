From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: Debug scsi message in linux 4.19.31
Date: Sun, 24 Mar 2019 09:18:58 -0700
Message-ID: <25d0ddcb-b603-6e0d-d512-b188813837bf@infradead.org>
References: <624bbdbb24ad7db69be29956cbf14689fd003cdb.camel@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <624bbdbb24ad7db69be29956cbf14689fd003cdb.camel@gmx.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hussam Al-Tayeb <ht990332@gmx.com>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

[adding linux-scsi and mkp]

On 3/24/19 6:07 AM, Hussam Al-Tayeb wrote:
> Hi. I'm seeing a debug message in linux stable kernel 4.19.31 with this
> patch
> scsi-sd-optimal-i-o-size-should-be-a-multiple-of-physical-block-
> size.patch
> 
> I am getting:
> Mar 23 17:40:10 hades kernel: sd 0:0:0:0: [sda] Optimal transfer size 0
> bytes < PAGE_SIZE (4096 bytes)
> Mar 23 17:40:10 hades kernel: sd 2:0:0:0: [sdb] Optimal transfer size 0
> bytes < PAGE_SIZE (4096 bytes)
> Mar 23 17:46:43 hades kernel: sd 4:0:0:0: [sdc] Optimal transfer size 0
> bytes < PAGE_SIZE (4096 bytes)
> 
> sda and sdb are physically attached SATA mechanical disks (Western
> Digital and Seagate, respectively).
> sdc is a kingston usb flash drive. All three disks use ext4 luks
> encrypted partitions.
> Is the fact that it is reporting 0 as optimal transfer size something I
> should worry about? Note that the the three storage devices are from
> three different manufacturers.
> This particular machine is a Lenovo Intel(R) Core(TM) i5-6400 CPU @
> 2.70GHz with 16GB Kingston DDR4 ram.
> 
> I tried moving the root disk to another machine (a DELL Core I7 7700
> with slightly faster ram from Samsung) and I saw the same message.
> 
> This seems like a patch that fits better in a hardware vendor or
> operating system distributor tree than the upstream kernel. Shouldn't
> stable tree kernels only contain direct fixes and regression fixes?
> Does it really belong in an LTS kernel?
> 
> Please CC me in your reply as I am not subscribed to the list.
> Thank you.
> 


-- 
~Randy
