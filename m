From: IW News <news@imagedworld.com>
Subject: Fwd: Re: SAS disk from RAID card (no RAID mode) problems
Date: Tue, 27 Dec 2016 09:01:34 +0100
Message-ID: <b7eb1617-ae24-996b-d0ee-9277b9052064@imagedworld.com>
References: <ed04b869-cc0f-b099-95a8-fc1ce08a1427@imagedworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hathor.lunarpages.com ([74.50.26.40]:49742 "EHLO
        hathor.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbcL0ICD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Dec 2016 03:02:03 -0500
Received: from 171.pool80-103-211.dynamic.orange.es ([80.103.211.171]:33024 helo=[192.168.123.100])
        by hathor.lunarpages.com with esmtpa (Exim 4.87)
        (envelope-from <news@imagedworld.com>)
        id 1cLmhu-000I4A-7I
        for linux-scsi@vger.kernel.org; Tue, 27 Dec 2016 00:02:02 -0800
In-Reply-To: <ed04b869-cc0f-b099-95a8-fc1ce08a1427@imagedworld.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 26/12/16 22:25, Thomas Fjellstrom wrote:

> On Friday, December 23, 2016 9:01:40 AM MST IW News wrote:
>> Hello,
>>
>> First message here.
>>
>> After looking for a solution without any luck I have found this list. I
>> hope someone can help me with this.
>>
>> I have an ASUS P6T Deluxe with a MARVELL 88SE63xx SAS RAID controller.
>> There are to identical 400GB SAS SSD drives attached to it. One of them
>> has a Windows 10 installation, the other one Linux.
>> Grub is installed on the second disk.
>>
>> Windows works as expected, but I have problems with the Linux
>> installation: the desktop environment freezes for some second once in a
>> while. This occurs with Mint Cinnamon, OpenSuSe KDE, Ubuntu and Manjaro
>> KDE. All of them are current installations. I'm now working in up to
>> date Manjaro KDE (kernel 4.9.0).
>> When the temporary freezes occur the mouse pointer moves, some windows
>> are updated correctly, other do not and DE stops working.
>> When this happens always I have a system log like this:
> If thats the mvsas driver, god help you. I had nothing but troubles with it
> for a good year or two or possibly more and it was never fixed or really
> acknowledged, so I sold that card (a supermicro aoc-saslp-mv8) and picked up a
> IBM m1015 (LSI 9211-8i a-like) and haven't looked back.
>
> Basically it would reset a lot, and lock up. AND I believe it caused a lot of
> silent corruption as well.

Hi,

So there is no support for the mvsas driver?

The controller is integrated in the motherboard. I could by a PCIe one
but, what's the deal them?

Thank you.

Iñigo.

