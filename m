From: Willem Riede <wrlk@riede.org>
Subject: Re: buggy scsi_register behaviour in 2.5.51
Date: Wed, 18 Dec 2002 18:20:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021218232014.GS7990@linnie.riede.org>
References: <3DFE998E.1080103@interlog.com> <20021217114730.GE7990@linnie.riede.org> <3E006692.7020503@torque.net>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E006692.7020503@torque.net>; from dougg@torque.net on Wed, Dec 18, 2002 at 07:14:10 -0500
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On 2002.12.18 07:14 Douglas Gilbert wrote:
> Willem,
> ide-scsi in lk 2.5 ...
> a) needs .eh_bus_reset_handler defined in idescsi_template
>     and implemented. It probably would be a dummy unless there
>     is a clean way to do an ATAPI bus (or device) reset.
> b) replace .detect and .release in idescsi_template with the
>     slave_alloc, slave_configure and slave_destroy interface
> 
And do request_sense itself as prescibed by the "new" error
handling I assume.

I'll be back with code when I have it.

Thanks, Willem Riede.
