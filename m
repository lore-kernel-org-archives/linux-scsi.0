From: Chunwei Chen <tuxoko@gmail.com>
Subject: [uas/3.16.1] panic in uas_data_cmplt()
Date: Tue, 02 Sep 2014 12:18:17 +0800
Message-ID: <54054509.2070609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dear all:

The kernel version is 3.16.1-1-ARCH

Today I keep getting this panic when booting up.
http://i.imgur.com/0Rx93Kr.jpg

It might be that the UAS device was in some strange state,
because that after I unplugged and power-cycled the UAS,
everything went normal again.

Does anyone know what's the root cause of this issue?
Or could anyone provide some instruction on how to debug this issue?

Thanks
