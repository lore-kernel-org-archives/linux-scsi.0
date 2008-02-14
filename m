From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: "gdth: update deprecated pci_find_device" is incorrect
Date: Thu, 14 Feb 2008 16:02:13 +0100
Message-ID: <47B457F5.8010306@gmail.com>
References: <47B453D3.5060707@gmail.com> <47B45469.5070103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758503AbYBNPCc@vger.kernel.org>
In-Reply-To: <47B45469.5070103@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Sergio Luis <sergio@larces.uece.br>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/14/2008 03:47 PM, Jiri Slaby wrote:
> On 02/14/2008 03:44 PM, Jiri Slaby wrote:
>> commit
>> 99109301d103fbf0de43fc5a580a406c12a501e0
>> in jejb/scsi-rc-fixes-2.6.git is incorrect. You don't decrement pci 
[...]
> BTW if you have more than one card, you protected the driver from no 
> race, since you don't pci_dev_get of successfully grabbed cards.

(this still holds)
