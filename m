From: Willem Riede <wrlk@riede.org>
Subject: Re: buggy scsi_register behaviour in 2.5.51
Date: Fri, 20 Dec 2002 09:46:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021220144648.GW7990@linnie.riede.org>
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
> 
> These are documented in Documentation/scsi/scsi_mid_low_api.txt .
> If you find mistakes or the explanation is not clear then
> complain to me. 

Your doc doesn't define the second parameter to scsi_add_host.
Can you explain what the purpose is of the struct device *dev
and how I'm supposed to pull one out of my hat in __init?
I notice that the old style registration doesn't bother with
shost->host_gendev.

Thanks, Willem Riede.
