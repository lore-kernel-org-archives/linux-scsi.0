From: Sumit Agarwal <aksumit@india.hp.com>
Subject: Re: doubt in sg, in sending SCSI CDB
Date: Fri, 08 Nov 2002 12:44:46 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DCC061E.7C8BE5C6@india.hp.com>
References: <F186ieLYCT4aJ6pkNzP00000031@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------27714257FBEA260A3E371C9B"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: shankar krishna <kshan01@hotmail.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------27714257FBEA260A3E371C9B
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit

> 2. Then a FCP DATA is done with my Inquiry CDB command
> going as "data".(since I used a write on that fd)

becoz you are sending this as a same exchange. Try to send
different commands as part of different exchanges or else
they must be linked commands. After the write the target
would change the phase to DATA OUT and thatz why you are
seeing such behaviour.


shankar krishna wrote:
> 
> >shankar krishna wrote:
> >>Hi,
> >>
> >>I just run the program that was given in end of
> >>SCSI-Programming-HOWTO, sending a Inquiry command.
> >
> >That HOWTO is pretty old and has been replaced by:
> >http://tldp.org/HOWTO/SCSI-Generic-HOWTO
> Yes. I looked into this. But even this does not allow me
> to send CDBs in FC(FCP-2). When I see a in FC analyzer
> between disk drive and HBA, it shows me
> 1. An Ex Write is done first.
> 2. Then a FCP DATA is done with my Inquiry CDB command
> going as "data".(since I used a write on that fd)
> 
> I dont want this. What I want is...in the first instant
> itself I want the INQUIRY cmd to be sent. Why I am
> trying to do this is... to finally be able to send
> a vendor specific CDBs through FC HBA where "our"
> target can analyse those and take
> specific action ...rather than standard ones.
> >
> >>I have IBM FC drive with Qlogic FC HBA. The
> >>device /dev/sda1 is able to open.
> >>
> >>When I read the vendor information (at offset 8), the
> >>file is spitting Junk. The only change I did to that
> >>program is  change the device file from “/dev/sg”
> >>to “/dev/sda1”.
> >
> >Ouch. That example program can only be used against sg
> >devices (and it is a shortcoming of the old HOWTO's
> >example program that it doesn't tell you at run time).
> >For more recent example programs you may like to try
> >sg3_utils found at
> >http://www.torque.net/sg (or freshmeat.net).
> This was very useful. Since I am dealing with
> sda( FC disk drives), can I use these to send my
> SCSI cmds? Is there any api's available where I
> can just fill 10 Byte CDB(Any command) and send
> to the target and try to interpret the reponse
> myself?? (Like ASPI available for Windows??)
> ---very similar to sendASPI32Command in adaptec ASPI ----
> 
> >There are several examples of INQUIRY programs (e.g.
> >sg_inq).
> >
> ><snip/>
> >
> >Doug Gilbert
> 
> Thanks again.
> Shankar.
> 
> _________________________________________________________________
> MSN 8 with e-mail virus protection service: 2 months FREE*
> http://join.msn.com/?page=features/virus
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--------------27714257FBEA260A3E371C9B
Content-Type: text/x-vcard; charset=us-ascii;
 name="aksumit.vcf"
Content-Transfer-Encoding: 7bit
Content-Description: Card for Sumit Agarwal
Content-Disposition: attachment;
 filename="aksumit.vcf"

begin:vcard 
n:Agarwal;Sumit
tel;fax:(91)(80)2200196
tel;home:+919845205210
tel;work:2051126
x-mozilla-html:FALSE
url:www.hp.com
org:HP-ISO;HPUX
version:2.1
email;internet:aksumit@india.hp.com
title:Senior Software Engineer
adr;quoted-printable:;;Hewlett-Packard,=0D=0AIndia Software Operation Pvt. Ltd.,=0D=0A29, Cunningham Road,=0D=0A;Bangalore;Karnataka;560052;India
fn:Sumit Agarwal
end:vcard

--------------27714257FBEA260A3E371C9B--

