From: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] mptscsih: MODULE_PARM() -> module_param()
Date: Wed, 6 Apr 2005 00:10:02 +0200
Message-ID: <aec7e5c3050405151072e73292@mail.gmail.com>
References: <91888D455306F94EBD4D168954A9457C01DBBC2C@nacos172.co.lsil.com>
Reply-To: Magnus Damm <magnus.damm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.202]:24774 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261853AbVDEWKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2005 18:10:04 -0400
Received: by wproxy.gmail.com with SMTP id 36so170045wri
        for <linux-scsi@vger.kernel.org>; Tue, 05 Apr 2005 15:10:03 -0700 (PDT)
In-Reply-To: <91888D455306F94EBD4D168954A9457C01DBBC2C@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Magnus Damm <damm@opensource.se>, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, mpt_linux_developer@lsil.com

On Apr 5, 2005 10:30 PM, Moore, Eric Dean <Eric.Moore@lsil.com> wrote:
> Ok fine - This fix is already there in the series of patches
> I provided a week ago for splitting the mpt fusion drivers
> into seperate bus type drivers.

Ah. I guess that makes this patch pretty useless, except in the case
where you want a quick fix for the possible problem related to the
"h"-parameter type mapped to an int.

/ magnus
