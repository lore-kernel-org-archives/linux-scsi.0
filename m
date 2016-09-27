From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: UFS API in the kernel
Date: Tue, 27 Sep 2016 10:10:51 +0900
Message-ID: <009f01d2185b$fcf71ef0$f6e55cd0$@samsung.com>
References: <c6a8636a-98e6-61d0-ff4b-350fb3869699@synopsys.com>
 <CGME20160926192330epcas2p4efa9f5e69c8591b6858a3eeb6290c986@epcas2p4.samsung.com>
 <CAJVOszALc04xgNujHi2YdCGpTXNWDoyLVwYT2uSYy6faDLqmYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:38636 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756216AbcI0BUx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 21:20:53 -0400
In-reply-to: <CAJVOszALc04xgNujHi2YdCGpTXNWDoyLVwYT2uSYy6faDLqmYA@mail.gmail.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Shaun Tancheff' <shaun.tancheff@seagate.com>, 'Joao Pinto' <Joao.Pinto@synopsys.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi.

If you want to declare some things for user interface,
is it be better to put those thing include/uapi/linux/ than include/linux?

Agreed with Mr. Pinto's opinion with respect to implementing additional ioctls.

Regards.

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Shaun Tancheff
> Sent: Tuesday, September 27, 2016 4:23 AM
> To: Joao Pinto
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: UFS API in the kernel
> 
> On Thu, Sep 22, 2016 at 10:21 AM, Joao Pinto <Joao.Pinto@synopsys.com>
> wrote:
> > Hi!
> >
> > I am designing an application that has the goal to be an utility for
> > Unipro and UFS testing purposes. This application is going to run on
> > top of a recent Linux Kernel containing the new UFS stack (including the
> new DWC drivers).
> >
> > I am considering doing the following:
> > a) Create a new config item called CONFIG_UFS_CHARDEV which is going
> > to create a char device responsible to make some IOCTL available for
> > user-space applications
> > b) Create a linux/ufs.h header file that contains data structures
> > declarations that will be needed in user-space applications
> 
> I am not very familiar with UFS devices, that said you should have an sgX
> chardev being created already so you can handle SG_IO requests.
> There also appear to be some sysfs entries being created.
> 
> So between sg and sysfs you should be able to handle any user-space out of
> band requests without resorting to making a new chardev.
> 
> Adding more sysfs entries, if you need them, should be fine.
> 
> You may find it easier to expand on the existing interfaces than to get
> consensus on a new driver and ioctls.
> 
> Hope this helps,
> Shaun
> 
> > Could you please advise me about what the correct approach should be
> > to make it as standard as possible and usable in the future?
> >
> > Thank you very much for your help!
> >
> > regards,
> > Joao
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at
> > https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_ma
> > jordomo-2Dinfo.html&d=DQICaQ&c=IGDlg0lD0b-nebmJJ0Kp8A&r=Wg5NqlNlVTT7Ug
> > l8V50qIHLe856QW0qfG3WVYGOrWzA&m=vJFB6pCywWtdvkgHz9Vc0jQz0xzeyZlr-7eCWY
> > u88nM&s=yiQLPFpqmMrbqLZz1Jb3aNqOje2dRMLJHEzUDobwcXc&e=
> 
> 
> 
> --
> Shaun Tancheff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


