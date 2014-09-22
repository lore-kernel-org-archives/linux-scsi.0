From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 4/4] target: Add a user-passthrough backstore
Date: Mon, 22 Sep 2014 14:00:51 -0700
Message-ID: <54208E03.8030906@redhat.com>
References: <1410822750-10717-1-git-send-email-agrover@redhat.com>	 <1410822750-10717-5-git-send-email-agrover@redhat.com>	 <1411161279.23258.26.camel@haakon3.risingtidesystems.com>	 <lvi81j$ud8$2@ger.gmane.org>	 <1411169965.23258.45.camel@haakon3.risingtidesystems.com>	 <lvifie$emi$3@ger.gmane.org> <541CCBD1.8050606@redhat.com> <1411419532.24986.36.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411419532.24986.36.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Alex Elsayed <eternaleye@gmail.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/22/2014 01:58 PM, Nicholas A. Bellinger wrote:
> So I'd still like to start for an initial merge with the two different
> modes mentioned earlier.  The pure-passthrough mode where everything is
> handled by user-space, and an I/O passthrough mode where only
> SCF_SCSI_DATA_CDB is passed along to userspace, but all other control
> CDBs are handled by existing in-kernel emulation.
>
> Andy, can you re-spin a series with these two approaches in mind..?

Will do. This is actually close to what the initial RFC version I posted 
did.

-- Andy
