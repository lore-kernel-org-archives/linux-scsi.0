From: Doug Ledford <dledford@redhat.com>
Subject: Re: problem with SCSI tape/linux
Date: Wed, 12 Jun 2002 12:25:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020612122559.B3946@redhat.com>
References: <Pine.LNX.4.44.0206121403160.26529-100000@shire.zend.office>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0206121403160.26529-100000@shire.zend.office>; from stas@zend.com on Wed, Jun 12, 2002 at 02:03:36PM +0300
List-Id: linux-scsi@vger.kernel.org
To: Stanislav Malyshev <stas@zend.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jun 12, 2002 at 02:03:36PM +0300, Stanislav Malyshev wrote:
> Jun 12 12:24:53 cheese kernel: st0: Error with sense data: [valid=0] Info 
> fld=0x0, Current st09:00: sense key Aborted Command
> Jun 12 12:24:53 cheese kernel: Additional sense indicates Data phase error

Sounds like either a bad cable or bad termination.  I would get a new 
cable and double check the connector on the tape drive to make sure there 
aren't any bent pins.  Also double check that your termination is correct.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
