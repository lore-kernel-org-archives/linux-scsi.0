From: Dmitry Yusupov <dmitry_yus@yahoo.com>
Subject: Re: [ANNOUNCE 0/6] Open-iSCSI High-Performance Initiator for Linux
Date: Thu, 10 Mar 2005 23:00:28 -0800
Message-ID: <1110524428.10402.4.camel@mylaptop>
References: <422BFCB2.6080309@yahoo.com> <20050309050434.GT3163@waste.org>
	 <422E8EEB.7090209@yahoo.com> <20050309060544.GW3120@waste.org>
	 <422E96D9.6090202@yahoo.com> <20050309222114.GF4105@marowsky-bree.de>
	 <422FB2B5.3070803@yahoo.com>  <20050310102726.GT4105@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from smtp104.mail.sc5.yahoo.com ([66.163.169.223]:19371 "HELO
	smtp104.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S263211AbVCKHAr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 02:00:47 -0500
In-Reply-To: <20050310102726.GT4105@marowsky-bree.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Alex Aizman <itn780@yahoo.com>, Matt Mackall <mpm@selenic.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2005-03-10 at 11:27 +0100, Lars Marowsky-Bree wrote:
> On 2005-03-09T18:36:37, Alex Aizman <itn780@yahoo.com> wrote:
> > >That works well in our current development series, and if you want to
> > >share code, you can either rip it off (Open Source, we love ya ;) or we
> > >can spin off these parts into a sub-package for you to depend on...
> > If it's not a big deal :-) let's do the "sub-package" option.
> 
> I've brought this up on the linux-ha-dev list. When do you need this?

For open-iscsi, I think it would make sense to link open-iscs daemon
code against klibc. The same way dm-multipath do. This will allow as to
build iSCSI remote boot using early user-space. Not sure it will be
possible to use your package without modifications. Let me know.

Dmitry

