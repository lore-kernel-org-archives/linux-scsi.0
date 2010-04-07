From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 07 Apr 2010 17:10:25 +0200
Message-ID: <4BBCA061.80906@gmail.com>
References: <Pine.LNX.4.44L0.1004071101560.1779-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1004071101560.1779-100000@iolanthe.rowland.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Lord <mlord@pobox.com>, dgilbert@interlog.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
List-Id: linux-scsi@vger.kernel.org

On 04/07/2010 05:03 PM, Alan Stern wrote:
> In that case, can you repeat the test using an EHCI controller instead
> of xHCI?

ffff8800345dbb40 2336453775 S Bo:1:004:2 -115 31 = 55534243 95000000 
00020000 80001085 082e0000 00010000 00000000 40ec00
ffff8800345dbb40 2336453948 C Bo:1:004:2 0 31 >
ffff880035f30f00 2336453969 S Bi:1:004:1 -115 512 <
ffff880035f30f00 2336459710 C Bi:1:004:1 0 512 = 4000ff3f 37c81000 
00000000 3f000000 00000000 32534d35 394a5a30 30313237
ffff8800345dbb40 2336459731 S Bi:1:004:1 -115 13 <
ffff8800345dbb40 2336459822 C Bi:1:004:1 0 13 = 55534253 95000000 
00000000 00
ffff8800345dbb40 2336460054 S Bo:1:004:2 -115 31 = 55534243 96000000 
00020000 80001085 082e0000 00010000 00000000 40a100
ffff8800345dbb40 2336460204 C Bo:1:004:2 0 31 >
ffff880035f30f00 2336460222 S Bi:1:004:1 -115 512 <
ffff880035f30f00 2336460472 C Bi:1:004:1 -32 0
ffff8800345dbb40 2336460492 S Co:1:004:0 s 02 01 0000 0081 0000 0
ffff8800345dbb40 2336460579 C Co:1:004:0 0 0
ffff8800345dbb40 2336460596 S Bi:1:004:1 -115 13 <
ffff8800345dbb40 2336460711 C Bi:1:004:1 0 13 = 55534253 96000000 
00020000 01
ffff8800345dbb40 2336460729 S Bo:1:004:2 -115 31 = 55534243 97000000 
60000000 80000603 00000060 00000000 00000000 000000
ffff8800345dbb40 2336460823 C Bo:1:004:2 0 31 >
ffff880035f30f00 2336460841 S Bi:1:004:1 -115 96 <
ffff880035f30f00 2336460952 C Bi:1:004:1 0 96 = 720b0000 0000000e 
090c0004 00010000 00000000 40510000 00000000 00000000
ffff8800345dbb40 2336460970 S Bi:1:004:1 -115 13 <
ffff8800345dbb40 2336461086 C Bi:1:004:1 0 13 = 55534253 97000000 
00000000 00
ffff8800345dbb40 2336462673 S Bo:1:004:2 -115 31 = 55534243 98000000 
00100000 80000a28 00000000 00000008 00000000 000000
ffff8800345dbb40 2336462826 C Bo:1:004:2 0 31 >
ffff880035f30f00 2336462844 S Bi:1:004:1 -115 4096 <
ffff880035f30f00 2336474954 C Bi:1:004:1 0 4096 = fab80010 8ed0bc00 
b0b80000 8ed88ec0 fbbe007c bf0006b9 0002f3a4 ea210600
ffff8800345dbb40 2336474975 S Bi:1:004:1 -115 13 <
ffff8800345dbb40 2336475078 C Bi:1:004:1 0 13 = 55534253 98000000 
00000000 00

Here you go.

-Jonas
