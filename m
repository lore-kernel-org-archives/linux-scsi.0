From: Andrey Astafyev <1@246060.ru>
Subject: Re: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate
 device
Date: Mon, 13 Nov 2017 09:16:39 +0300
Message-ID: <d09f29a5-295b-d95c-40ac-bba41bee5fc8@246060.ru>
References: <20171110151344.10563-1-hdegoede@redhat.com>
 <20171112164234.48b5185c@Vantage.cJ>
 <46d6dde9-e811-9655-96db-a046de521782@246060.ru>
 <20171113011438.458369bf@Vantage.cJ>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:51252 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdKMGQp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2017 01:16:45 -0500
Received: by mail-lf0-f54.google.com with SMTP id f134so8690067lfg.8
        for <linux-scsi@vger.kernel.org>; Sun, 12 Nov 2017 22:16:44 -0800 (PST)
In-Reply-To: <20171113011438.458369bf@Vantage.cJ>
Content-Language: ru-RU
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgQ2FycmV0ZXJv?= <cJ-ko@zougloub.eu>, Hans de Goede <hdegoede@redhat.com>
Cc: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

13.11.2017 09:14, Jérôme Carretero пишет:
> For my devices, adding US_FL_NO_ATA_1X to unusual_uas.h didn't
> change anything, and while adding US_FL_IGNORE_UAS (using
> quirks=0bc2:ab34:u,0bc2:ab38:u) there are still device resets,
> but they cause shorter hangs in system activity (~1 second when
> UAS was more like ~20).

Maybe you should try like this: quirks=0bc2:ab34:ut,0bc2:ab38:ut ?
