From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH] drivers/scsi/qla2xxx: fix double free bug after firmware
 timeout
Date: Thu, 7 Dec 2017 23:10:53 +0100
Message-ID: <20171207221053.krqfykp4y3w6impr@swift.blarg.de>
References: <151265800413.23884.12590131670697249849.stgit@rabbit.intern.cm-ag>
 <F250F948-C720-4D0C-8DCC-329E9FB6B1CA@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F250F948-C720-4D0C-8DCC-329E9FB6B1CA@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: Max Kellermann <mk@cm4all.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "max.kellermann@gmail.com" <max.kellermann@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2017/12/07 21:38, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com> wrote:
> NACK
> 
> These calls are asynchronous calls and free should be called by
> completion.

I don't understand the NACK, and your text doesn't explain it.  It
only describes a second bug that is orthogonal to mine.
