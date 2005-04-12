From: Dmitry Yusupov <dima@neterion.com>
Subject: Re: [ANNOUNCE 2/6] Linux-iSCSI High-Performance Initiator
Date: Tue, 12 Apr 2005 09:34:33 -0700
Message-ID: <1113323674.10545.5.camel@beastie>
References: <425B3F58.2040000@yahoo.com>  <20050412053532.GE32372@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.s2io.com ([142.46.200.198]:7402 "EHLO ns1.s2io.com")
	by vger.kernel.org with ESMTP id S262266AbVDLQfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 12:35:11 -0400
In-Reply-To: <20050412053532.GE32372@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Alex Aizman <itn780@yahoo.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2005-04-11 at 22:35 -0700, Greg KH wrote:
> On Mon, Apr 11, 2005 at 08:24:08PM -0700, Alex Aizman wrote:
> > +typedef uint64_t iscsi_snx_t;		/* iSCSI Data-Path session handle */
> > +typedef uint64_t iscsi_cnx_t;		/* iSCSI Data-Path connection handle */
> 
> Do you really have to create a new typedef?  Please reconsider.  Just
> use u64 everywhere, unless you need to do type checking...

it is a handle and it is used as a parameter in exported API. yes. type
checking exactly the reason.

Dima


