From: "Graham" <graham@soundclashchampions.com>
Subject: RE: aacraid version confusion
Date: Wed, 12 Oct 2005 11:47:08 -0700 (PDT)
Message-ID: <4540.69.15.46.10.1129142828.squirrel@69.15.46.10>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01B52042@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gnosis.slac.com ([208.185.215.36]:14805 "EHLO slac.com")
	by vger.kernel.org with ESMTP id S1751501AbVJLSrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 14:47:08 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01B52042@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Thank you very much, Mark.  I'm still confused about one thing.  In response
to my question about the latest "stable" version, you talk about versions
1.1.5-2409 and 1.1.5-2412, but on adaptec.com, I'm only finding 1.1.5-2326. 
>From the main page, I click Downloads, Linux Driver Source Code, AACRAID
1.1.5 Source Code File.  this allows me to download 1.1.5-2326, dated 1 Mar
2004.  Am I looking in the wrong place?

Thanks again,
  Graham



> I am confused too ...
>
> 1.1.2-lk2 in 2.6.10 is roughly 1.1.4-2322 from the Adaptec Stream in
> heritage. 1.1.2-lk2 in 2.6.12 is roughly 1.1.4-2337. By roughly, there
> is stuff from 1.1.3 that is still missing due to 'priorities'.
>
> Each tiny individual patches to change the kernel.org driver to bring it
> into synchronization with the Adaptec Branch of the driver have never
> had an accompanying version change incorporated into them until
> recently. The lack of version movement is a direct result of the major
> steps we make here to keep the driver stable, and the resultant
> multitude of tiny out-of-order patches that are necessary to move those
> changes into the kernel.org tree.
>
> Only recently have the 'version' patches made it in. The driver is *now*
> 1.1.4 in 2.6.14-rc and is now starting to get the 1.1.5 patches pushed
> into the pipe. Once those have made it in (no timeframe), we will send a
> patch to push the version up to 1.1.5. These patches are mainly
> associated with the changes to move to the 'new comm' interface; a major
> performance improvement for this line of adapters.
>
> As for latest stable, 1.1.5-2409 is in the hands of Adaptec's technical
> support department. Older versions are kept around as they form
> certified combinations with specific hardware. The latest version,
> however, should always be good to go with *any* legacy hardware. We are
> at 1.1.5-2412 right now and supply the latest in my hands on demand.
>
> The driver as released from Adaptec is meant to be universal, and the
> latest will compile in anything from 2.4.2 to 2.6.14 through the power
> of Makefile and Source ifdef. The '2.6 purity cleansed' version of the
> driver is only a dozen patches ahead of the driver in 2.6.14-rc4. I
> still stand in awe of the sed script I use to cleans the sources of all
> the ifdefs ...
>
> Sincerely -- Mark Salyzyn
>
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Graham
> Sent: Wednesday, October 12, 2005 1:24 PM
> To: linux-scsi@vger.kernel.org
> Subject: aacraid version confusion
>
>
> I'm thoroughly confused about the versioning of the aacraid driver, and
> would very much appreciate it if someone could explain to me how it
> works.
>
> Firstly, I've found that the source for the aacraid driver differs
> vastly between kernels 2.6.8 and 2.6.13, yet both have the driver
> labeled as version "1.1.2-lk2".  If the code changed, shouldn't the
> version label change?
>
> Secondly, I don't understand what the 1.1.5 line is.  Where is the
> source code kept?  Is it actively merged into the mainline kernel
> source?  I found version 1.1.5-2326 on adaptec.com, seen talk of
> 1.1.5-2345 on this list, and found 1.1.5-2392 on dell.com.
>
> Thirdly, what is considered the latest "stable" version?
>
> Thanks in advance,
>   Graham
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


:: http://www.soundclashchampions.com/ ::

