From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM ATTEND] iSCSI/iSER MQ + EXTENDED_COPY host support
Date: Thu, 08 Jan 2015 14:19:50 -0800
Message-ID: <1420755590.2842.17.camel@haakon3.risingtidesystems.com>
References: <1420665695.12144.62.camel@haakon3.risingtidesystems.com>
	 <54ADAF09.8050405@interlog.com> <54AED355.5030705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54AED355.5030705@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: dgilbert@interlog.com, lsf-pc <lsf-pc@lists.linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-01-08 at 10:58 -0800, Andy Grover wrote:
> On 01/07/2015 02:11 PM, Douglas Gilbert wrote:
> > T10 have now dropped the LID1 and LID4 stuff (its the length
> > of the LIST IDENTIFIER field: 1 byte or 4 bytes) by obsoleting
> > all LID1 variants in SPC-5 revision 01. So the LID1 variants
> > are now gone and the LID4 appendage is dropped from the remaining
> > commands.
> >
> > Obviously LID1 based XCOPY support is important for backward
> > compatibility (back to SPC-2) but for the future maybe you might
> > consider adding the equivalent LID4 support for a basic XCOPY.
> > For example it means using the 3PC VPD page instead of the
> > RECEIVE COPY RESULTS(operating parameters) command. I believe
> > FreeNAS now supports both LID1 and LID4 variants of a basic
> > XCOPY (plus a restricted version of ODX without snapshots).
> 
> Hi Doug,
> 
> I was trying to learn more about ODX and saw this page:
> 
> http://msdn.microsoft.com/en-us/library/windows/desktop/hh848056%28v=vs.85%29.aspx
> 
> but it just muddied the waters for me. Is ODX proprietary to MS, or is 
> it XCopy lite, or what? And what's the difference between xcopy lite and 
> LID4 XCOPY?
> 

xcopy-lite in MSFT speak and LID4 XCOPY in T10 speak are the same thing.
EG: Tokenized XCOPY where all reads from the copy source are done from a
point-in-time snapshot.

--nab
